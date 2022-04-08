//
//  HomeViewController.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 25/03/22.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private var transactions:[Transaction] = [Transaction]()
    private let transactionManager:TransactionManager = TransactionManager()
    private var balanceViewModels:[BalanceCollectionViewCell.ViewModel] = [BalanceCollectionViewCell.ViewModel]()
    private var transactionsObserver:NSObjectProtocol?
    
    // MARK: - UI
    
    private let emptyView:EmptyView = EmptyView()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            return HomeViewController.layout(for: section)
        }
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "cell")
        collectionView.register(
            BalanceCollectionViewCell.self,
            forCellWithReuseIdentifier: BalanceCollectionViewCell.identifier)
        collectionView.register(
            TransactionListCollectionViewCell.self,
            forCellWithReuseIdentifier: TransactionListCollectionViewCell.identifier)
        collectionView.register(
            HomeHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeHeaderCollectionReusableView.identifier)
        collectionView.register(
            HeaderTitleCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderTitleCollectionReusableView.identifier)
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Dashboard"
        view.backgroundColor = .systemBackground
        setupBarButtonItems()
        view.addSubviews(emptyView,collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        setupObserver()
        fetchTransactions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        emptyView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.width,
            height: view.height-view.safeAreaInsets.top)
    }
    
    // MARK: - Private
        
    /// Sets up navigation bar button items
    private func setupBarButtonItems() {
        
        let button = IconTextButton(frame: .zero)
        button.delegate = self
        button.configure(with: .init(title: "Wallet"))
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image: UIImage(systemName: "plus.circle"),
                style: .plain,
                target: self,
                action: #selector(didTapAdd)),
            UIBarButtonItem(
                image: UIImage(systemName: "gear"),
                style: .plain,
                target: self,
                action: #selector(didTapSettings))]
    }
    
    @objc private func didTapAdd() {
        let vc:AddExpenseScreenOneViewController = AddExpenseScreenOneViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapSettings() {
        let vc:SettingsViewController = SettingsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupObserver() {
    transactionsObserver = NotificationCenter.default.addObserver(
            forName: .refreshTransactions,
            object: nil,
            queue: .main) { [weak self] _ in
                self?.fetchTransactions()
            }
    }
    
    private func fetchTransactions() {
        transactions.removeAll()
        balanceViewModels.removeAll()
        if let transactions = transactionManager.fetchTransactions() {
            self.transactions = transactions
            balanceViewModels.append(.init(type: ExpenseTypeCollectionViewCell.ExpenseType.income,
                                           balance: transactionManager.fetchBalance(of: .income)))
            balanceViewModels.append(.init(type: ExpenseTypeCollectionViewCell.ExpenseType.expense,
                                           balance: transactionManager.fetchBalance(of: .expense)))
        }
        DispatchQueue.main.async { [weak self] in
            self?.updateUI()
        }
    }
    
    private func updateUI() {
        if transactions.isEmpty {
            emptyView.isHidden = false
            collectionView.isHidden = true
        } else {
            emptyView.isHidden = true
            collectionView.isHidden = false
        }
        collectionView.reloadData()
    }
}

// MARK: - Extension - UICollectionView

extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return min(transactions.count, 5)
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell:BalanceCollectionViewCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BalanceCollectionViewCell.identifier,
                for: indexPath) as? BalanceCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: balanceViewModels[indexPath.item])
            return cell
        case 1:
            guard let cell:TransactionListCollectionViewCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TransactionListCollectionViewCell.identifier,
                for: indexPath) as? TransactionListCollectionViewCell else {
                return UICollectionViewCell()
            }
            let transaction = transactions[indexPath.item]
            cell.configure(with: transaction)
            return cell
        default:
            let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            cell.backgroundColor = .systemOrange
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
        case 0:
            guard kind == UICollectionView.elementKindSectionHeader,
                  let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: HomeHeaderCollectionReusableView.identifier,
                    for: indexPath) as? HomeHeaderCollectionReusableView else {
                return UICollectionReusableView()
            }
            header.configure(
                with: .init(
                    balance: transactionManager.fetchTotalBalance(),
                    entries: [
                        ExpenseTypeCollectionViewCell.ExpenseType.expense.title:transactionManager.fetchBalance(of: .expense),
                        ExpenseTypeCollectionViewCell.ExpenseType.income.title:transactionManager.fetchBalance(of: .income)
                    ]))
            return header
        default:
            guard kind == UICollectionView.elementKindSectionHeader,
                  let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: HeaderTitleCollectionReusableView.identifier,
                    for: indexPath) as? HeaderTitleCollectionReusableView else {
                return UICollectionReusableView()
            }
            header.backgroundColor = .secondarySystemBackground
            header.configure(
                with: "Recent Transactions",
                showViewAll: (transactions.count > 5) ? true : false)
            header.delegate = self
            return header
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        HapticsManager.shared.vibrateForSelection()
        switch indexPath.section {
        case 0:
            let viewModel:BalanceCollectionViewCell.ViewModel = balanceViewModels[indexPath.item]
            let vc:TransactionExpenseTypeListViewController = TransactionExpenseTypeListViewController(type: viewModel.type,
                                                              balance: viewModel.balance)
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let transaction:Transaction  = transactions[indexPath.item]
            let vc:ExpenseDetailedViewController = ExpenseDetailedViewController(transaction: transaction)
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }

}

// MARK: - Extension - HeaderTitleCollectionReusableViewDelegate

extension HomeViewController: HeaderTitleCollectionReusableViewDelegate {

    func headerTitleCollectionReusableViewDidTapViewAll(_ cell: HeaderTitleCollectionReusableView) {
        let vc:TransactionListViewController = TransactionListViewController(transactions: transactions)
        navigationController?.pushViewController(vc, animated: true)
    }

}

// MARK: - Extension - HomeViewController

extension HomeViewController {
    
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
       
       let sectionOneSupplementaryViews:[NSCollectionLayoutBoundarySupplementaryItem] = [
           NSCollectionLayoutBoundarySupplementaryItem(
               layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .absolute(250)),
               elementKind: UICollectionView.elementKindSectionHeader,
               alignment: .top
           )
       ]
       
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
           let section:NSCollectionLayoutSection = createSection(with: .fractionalWidth(0.5),
                                       heightDimension: .absolute(150),
                                       count: 2)
           section.boundarySupplementaryItems = sectionOneSupplementaryViews
           return section
       case 1:
           let section:NSCollectionLayoutSection = createSection(with: .fractionalWidth(1),
                                       heightDimension: .absolute(70),
                                       count: 1)
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

extension HomeViewController: IconTextButtonDelegate {
    
    func iconTextButtonTapped(_ button: IconTextButton) {
        print("tapped!!!!")
    }
   
}
