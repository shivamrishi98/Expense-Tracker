//
//  HomeViewController.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 25/03/22.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private var transactions = [Transaction]()
    private let transactionManager = TransactionManager()
    private var balanceViewModels = [BalanceCollectionViewCell.ViewModel]()
    private var transactionsObserver:NSObjectProtocol?
    
    // MARK: - UI
    
    private let emptyView = EmptyView()
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle"),
            style: .plain,
            target: self,
            action: #selector(didTapAdd))
    }
    
    @objc private func didTapAdd() {
        let vc = AddExpenseScreenOneViewController()
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
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BalanceCollectionViewCell.identifier,
                for: indexPath) as? BalanceCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: balanceViewModels[indexPath.item])
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TransactionListCollectionViewCell.identifier,
                for: indexPath) as? TransactionListCollectionViewCell else {
                return UICollectionViewCell()
            }
            let transaction = transactions[indexPath.item]
            cell.configure(with: transaction)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
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
            header.backgroundColor = .secondarySystemBackground
            header.configure(with: transactionManager.fetchTotalBalance())
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
        switch indexPath.section {
        case 0:
            let vc = TransactionExpenseTypeListViewController(type: balanceViewModels[indexPath.item].type)
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let transaction = transactions[indexPath.item]
            let vc = ExpenseDetailedViewController(transaction: transaction)
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }

}

// MARK: - Extension - HeaderTitleCollectionReusableViewDelegate

extension HomeViewController: HeaderTitleCollectionReusableViewDelegate {

    func headerTitleCollectionReusableViewDidTapViewAll(_ cell: HeaderTitleCollectionReusableView) {
        let vc = TransactionListViewController(transactions: transactions)
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
       
       let sectionOneSupplementaryViews = [
           NSCollectionLayoutBoundarySupplementaryItem(
               layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .absolute(100)),
               elementKind: UICollectionView.elementKindSectionHeader,
               alignment: .top
           )
       ]
       
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
           let section = createSection(with: .fractionalWidth(0.5),
                                       heightDimension: .absolute(150),
                                       count: 2)
           section.boundarySupplementaryItems = sectionOneSupplementaryViews
           return section
       case 1:
           let section = createSection(with: .fractionalWidth(1),
                                       heightDimension: .absolute(70),
                                       count: 1)
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

