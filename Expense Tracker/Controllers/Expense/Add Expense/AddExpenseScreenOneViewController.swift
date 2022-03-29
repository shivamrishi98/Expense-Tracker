//
//  AddExpenseViewController.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 25/03/22.
//

import UIKit

struct AddExpenseModel {
    let title:String
    let type:String
    let category:String
    let amount:Double
    let note:String
    let createdAt:Date
    let updatedAt:Date
}

struct AddExpenseScreenOneModel {
    let title:String
    let type:String
    let category:String
}

final class AddExpenseScreenOneViewController: UIViewController {

    // MARK: - Properties
    private let sections = ["","Type","Category"]
    private var titleString:String? = nil
    private let types = ExpenseTypeCollectionViewCell.ExpenseType.allCases
    private let expenseCategories = ExpenseCategoryCollectionViewCell.Category.Expense.allCases.filter({ $0 != .none })
    private let incomeCategories = ExpenseCategoryCollectionViewCell.Category.Income.allCases.filter({ $0 != .none })
    private var selectedType:ExpenseTypeCollectionViewCell.ExpenseType = .income
    
    private var selectedIncomeCategory:ExpenseCategoryCollectionViewCell.Category.Income = .none
    private var selectedExpenseCategory:ExpenseCategoryCollectionViewCell.Category.Expense = .none
    
    
    // MARK: - UI
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            return AddExpenseScreenOneViewController.layout(for: section)
        }
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.register(
            ExpenseTextfieldCollectionViewCell.self,
            forCellWithReuseIdentifier: ExpenseTextfieldCollectionViewCell.identifier)
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Transaction"
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        setupBarButtonItems()
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
        guard let title = titleString,
              !title.trimmingCharacters(in: .whitespaces).isEmpty,
              selectedIncomeCategory != .none || selectedExpenseCategory != .none else {
            return
        }
        var category = ""
        switch selectedType {
        case .income:
            category = selectedIncomeCategory.title
        case .expense:
            category = selectedExpenseCategory.title
        }
        let model = AddExpenseScreenOneModel(title: title ?? "",
                                             type: selectedType.title,
                                             category: category)
        let vc = AddExpenseScreenTwoViewController(addExpenseScreenOneModel: model)
        navigationController?.pushViewController(vc, animated: true)
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
            return types.count
        case 2:
            return (selectedType == .expense) ? expenseCategories.count : incomeCategories.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExpenseTextfieldCollectionViewCell.identifier,
                for: indexPath) as? ExpenseTextfieldCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            cell.configure(with: titleString ?? "")
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExpenseTypeCollectionViewCell.identifier,
                for: indexPath) as? ExpenseTypeCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            cell.expenseTypeView.backgroundColor = (selectedType == types[indexPath.item]) ? .secondarySystemFill : .secondarySystemBackground
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
        case 2:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExpenseCategoryCollectionViewCell.identifier,
                for: indexPath) as? ExpenseCategoryCollectionViewCell else {
                return UICollectionViewCell()
            }
            switch selectedType {
            case .income:
                let category = incomeCategories[indexPath.item]
                cell.configure(with: category.title,
                               iconName: category.iconName)
            case .expense:
                let category = expenseCategories[indexPath.item]
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
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderTitleCollectionReusableView.identifier,
                for: indexPath) as? HeaderTitleCollectionReusableView else {
            return UICollectionReusableView()
        }
        let title = sections[indexPath.section]
        header.configure(with: title)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 2:
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
                                       type: ExpenseTypeCollectionViewCell.ExpenseType) {
        DispatchQueue.main.async { [weak self] in
            self?.selectedType = type
            self?.selectedExpenseCategory = .none
            self?.selectedIncomeCategory = .none
            self?.collectionView.reloadData()
        }
    }
}

// MARK: - Extension - ExpenseTypeCollectionViewCellDelegate

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
        let itemSize = NSCollectionLayoutSize(widthDimension: widthDimension,
                                              heightDimension: heightDimension)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2,
                                                     leading: 2,
                                                     bottom: 2,
                                                     trailing: 2)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: count)
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private static func layout(for section: Int) -> NSCollectionLayoutSection {
        
        let supplementaryViews = [
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
        case 1:
            let section = createSection(with: .fractionalWidth(0.5),
                                        heightDimension: .absolute(50),
                                        count: 2)
            section.boundarySupplementaryItems = supplementaryViews
            return section
        case 2:
            let section = createSection(with: .fractionalWidth(0.3),
                                        heightDimension: .absolute(100),
                                        count: 3)
            section.boundarySupplementaryItems = supplementaryViews
            return section
        default:
            let section = createSection(with: .fractionalWidth(0.5),
                                        heightDimension: .absolute(50),
                                        count: 1)
            return section
        }
    }
    
}

