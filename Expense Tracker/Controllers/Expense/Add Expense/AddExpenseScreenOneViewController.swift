//
//  AddExpenseViewController.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 25/03/22.
//

import UIKit

final class AddExpenseScreenOneViewController: UIViewController {

    // MARK: - Properties
    private let sections:[String] = ["","Payment Method","Type","Category"]
    private var titleString:String? = nil
    private let paymentMethods:[PaymentMethod] = PaymentMethod.allCases.filter({ $0 != .all})
    private let types:[ExpenseType] = ExpenseType.allCases
    private let expenseCategories:[Category.Expense] = Category.Expense.allCases.filter({ $0 != .none })
    private let incomeCategories:[Category.Income] = Category.Income.allCases.filter({ $0 != .none })
    
    private var selectedPaymentMethod:PaymentMethod = .cash
    
    private var selectedType:ExpenseType = .income
    
    private var selectedIncomeCategory:Category.Income = .none
    private var selectedExpenseCategory:Category.Expense = .none
    private let transaction:Transaction?
    
    // MARK: - UI
    private let collectionView: UICollectionView = {
        let layout:UICollectionViewCompositionalLayout = UICollectionViewCompositionalLayout { section, _ in
            return AddExpenseScreenOneViewController.layout(for: section)
        }
        let collectionView:UICollectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.register(
            ExpenseTextfieldCollectionViewCell.self,
            forCellWithReuseIdentifier: ExpenseTextfieldCollectionViewCell.identifier)
        collectionView.register(
            ExpensePaymentMethodCollectionViewCell.self,
            forCellWithReuseIdentifier: ExpensePaymentMethodCollectionViewCell.identifier)
        collectionView.register(
            ExpenseTypeCollectionViewCell.self,
            forCellWithReuseIdentifier: ExpenseTypeCollectionViewCell.identifier)
        collectionView.register(
            ExpenseCategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: ExpenseCategoryCollectionViewCell.identifier)
        collectionView.register(
            HeaderTitleCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderTitleCollectionReusableView.identifier)
        return collectionView
    }()
    
    // MARK: - Init
    
    init(transaction:Transaction? = nil) {
        self.transaction = transaction
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Transaction"
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        setupBarButtonItems()
        fillValuesIfRecordExists()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    // MARK: - Private
    
    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Next",
            style: .plain,
            target: self,
            action: #selector(didTapNext))
    }
    
    @objc private func didTapNext() {
        guard let title:String = titleString,
              !title.trimmingCharacters(in: .whitespaces).isEmpty,
              selectedIncomeCategory != .none || selectedExpenseCategory != .none else {
            HapticsManager.shared.vibrate(for: .error)
            AlertManager.present(title: "Woops",
                                 message: "Please fill all the details",
                                 actions: .ok,
                                 from: self)
            return
        }
        HapticsManager.shared.vibrate(for: .success)
        var category:String = ""
        var categoryIconName:String = ""
        switch selectedType {
        case .income:
        category = selectedIncomeCategory.title
        categoryIconName = selectedIncomeCategory.iconName
        case .expense:
        category = selectedExpenseCategory.title
        categoryIconName = selectedExpenseCategory.iconName
        }
        let model:AddExpenseScreenOneModel = AddExpenseScreenOneModel(
            title: title,
            paymentMethod: selectedPaymentMethod.title,
            type: selectedType.title,
            category: category,
            iconName: categoryIconName)
        let vc:AddExpenseScreenTwoViewController = AddExpenseScreenTwoViewController(
            addExpenseScreenOneModel: model,
            transaction: transaction ?? nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func fillValuesIfRecordExists() {
        if let transaction:Transaction = transaction {
            titleString = transaction.title
            let cashPaymentMethodSelected:Bool = transaction.paymentMethod == PaymentMethod.cash.title
            selectedPaymentMethod = cashPaymentMethodSelected ? .cash : .online
            
            let incomeTypeSelected:Bool = transaction.type == ExpenseType.income.title
            selectedType = incomeTypeSelected ? .income : .expense
            switch selectedType {
            case .income:
                var item:Int = -1
                for (index,value) in incomeCategories.enumerated() where value.title == transaction.category {
                    item = index
                }
                let indexPath:IndexPath = IndexPath(item: item, section: 3)
                selectedIncomeCategory = incomeCategories[indexPath.item]
                collectionView.selectItem(at: indexPath,
                                          animated: true,scrollPosition:.top)
            case .expense:
                var item:Int = -1
                for (index,value) in expenseCategories.enumerated() where value.title == transaction.category {
                    item = index
                }
                let indexPath:IndexPath = IndexPath(item: item, section: 3)
                selectedExpenseCategory = expenseCategories[indexPath.item]
                collectionView.selectItem(at: indexPath,
                                          animated: true,scrollPosition:.top)
            }
        }
    }
}

// MARK: - EXTENSION - UICollectionView

extension AddExpenseScreenOneViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return paymentMethods.count
        case 2:
            return types.count
        case 3:
            return (selectedType == .expense) ? expenseCategories.count : incomeCategories.count
        default: 
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell:ExpenseTextfieldCollectionViewCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExpenseTextfieldCollectionViewCell.identifier,
                for: indexPath) as? ExpenseTextfieldCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            cell.configure(with: titleString ?? "")
            return cell
        case 1:
            guard let cell:ExpensePaymentMethodCollectionViewCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExpensePaymentMethodCollectionViewCell.identifier,
                for: indexPath) as? ExpensePaymentMethodCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            cell.expenseTypeView.backgroundColor = (selectedPaymentMethod == paymentMethods[indexPath.item]) ? .link : .secondaryLabel
            switch indexPath.item {
            case 0:
                cell.configure(with: .cash)
                return cell
            case 1:
                cell.configure(with: .online)
                return cell
            default:
                return UICollectionViewCell()
            }
        case 2:
            guard let cell:ExpenseTypeCollectionViewCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExpenseTypeCollectionViewCell.identifier,
                for: indexPath) as? ExpenseTypeCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            cell.expenseTypeView.backgroundColor = (selectedType == types[indexPath.item]) ? .link : .secondaryLabel
            switch indexPath.item {
            case 0:
                cell.configure(with: .income)
                return cell
            case 1:
                cell.configure(with: .expense)
                return cell
            default:
                return UICollectionViewCell()
            }
        case 3:
            guard let cell:ExpenseCategoryCollectionViewCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExpenseCategoryCollectionViewCell.identifier,
                for: indexPath) as? ExpenseCategoryCollectionViewCell else {
                return UICollectionViewCell()
            }
            switch selectedType {
            case .income:
                let category:Category.Income = incomeCategories[indexPath.item]
                cell.configure(with: category.title,
                               iconName: category.iconName)
            case .expense:
                let category:Category.Expense = expenseCategories[indexPath.item]
                cell.configure(with: category.title,
                               iconName: category.iconName)
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader,
              let header:HeaderTitleCollectionReusableView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderTitleCollectionReusableView.identifier,
                for: indexPath) as? HeaderTitleCollectionReusableView else {
            return UICollectionReusableView()
        }
        let title:String = sections[indexPath.section]
        header.configure(with: title)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        HapticsManager.shared.vibrateForSelection()
        switch indexPath.section {
        case 3:
            switch selectedType {
            case .income:
                selectedIncomeCategory = incomeCategories[indexPath.item]
            case .expense:
                selectedExpenseCategory = expenseCategories[indexPath.item]
            }
        default:
            break
        }
    }
}

 // MARK: - Extension - ExpenseTypeCollectionViewCellDelegate

extension AddExpenseScreenOneViewController: ExpenseTypeCollectionViewCellDelegate {
    func expenseTypeCollectionViewCell(_ cell: ExpenseTypeCollectionViewCell,
                                       type: ExpenseType) {
        DispatchQueue.main.async { [weak self] in
            self?.selectedType = type
            self?.selectedExpenseCategory = .none
            self?.selectedIncomeCategory = .none
            self?.collectionView.reloadData()
        }
    }
}

// MARK: - Extension - ExpensePaymentMethodCollectionViewCellDelegate

extension AddExpenseScreenOneViewController: ExpensePaymentMethodCollectionViewCellDelegate {
    
    func expensePaymentMethodCollectionViewCell(_ cell: ExpensePaymentMethodCollectionViewCell, paymentMethod: PaymentMethod) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.selectedPaymentMethod = paymentMethod
            let indexSet = IndexSet(integer: indexPath.section)
            self?.collectionView.reloadSections(indexSet)
        }
    }

}

// MARK: - Extension - ExpenseTextfieldCollectionViewCellDelegate

extension AddExpenseScreenOneViewController:ExpenseTextfieldCollectionViewCellDelegate {
    
    func expenseTextfieldCollectionViewCell(_ cell: ExpenseTextfieldCollectionViewCell, didUpdateField title: String) {
        titleString = title
    }
    
}

 // MARK: - Extension - AddExpenseScreenOneViewController

extension AddExpenseScreenOneViewController {
    
    private static func createSection(
        with widthDimension: NSCollectionLayoutDimension,
        heightDimension: NSCollectionLayoutDimension,
        count:Int
    ) -> NSCollectionLayoutSection {
        let itemSize:NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: widthDimension,
                                              heightDimension: heightDimension)
        let item:NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2,
                                                     leading: 2,
                                                     bottom: 2,
                                                     trailing: 2)
        
        let groupSize:NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: heightDimension)
        let group:NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: count)
        
        let section:NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private static func layout(for section: Int) -> NSCollectionLayoutSection {
        
        let supplementaryViews:[NSCollectionLayoutBoundarySupplementaryItem] = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(40)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        
        switch section {
        case 0:
            return createSection(with: .fractionalWidth(1),
                                 heightDimension: .absolute(50),
                                 count: 1)
        case 1,2:
            let section:NSCollectionLayoutSection = createSection(with: .fractionalWidth(0.5),
                                        heightDimension: .absolute(50),
                                        count: 2)
            section.boundarySupplementaryItems = supplementaryViews
            return section
        case 3:
            let section:NSCollectionLayoutSection = createSection(with: .fractionalWidth(0.3),
                                        heightDimension: .absolute(100),
                                        count: 3)
            section.boundarySupplementaryItems = supplementaryViews
            return section
        default:
            let section:NSCollectionLayoutSection = createSection(with: .fractionalWidth(0.5),
                                        heightDimension: .absolute(50),
                                        count: 1)
            return section
        }
    }
    
}

