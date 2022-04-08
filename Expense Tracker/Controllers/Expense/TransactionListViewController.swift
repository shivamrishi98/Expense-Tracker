//
//  TransactionListViewController.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 30/03/22.
//

import UIKit

final class TransactionListViewController: UIViewController {

    // MARK: - Properties
    
    private var transactions:[Transaction] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.updateUI()
            }
        }
    }
    private let originalTransactions:[Transaction]
    private let paymentMethod:PaymentMethod
    private let transactionManager:TransactionManager = TransactionManager()
    
    // MARK: - UI
    
    private let tableView:UITableView = {
       let tableView = UITableView()
        tableView.register(TransactionListTableViewCell.self,
                           forCellReuseIdentifier: TransactionListTableViewCell.identifier)
       return tableView
    }()
    
    private let emptyView:EmptyView = {
        let emptyView = EmptyView()
        emptyView.isHidden = true
        return emptyView
    }()
    
    private let searchBar:UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.placeholder = "Search by title,category..."
        searchBar.layer.cornerRadius = 8
        searchBar.layer.masksToBounds = true
        searchBar.autocorrectionType = .no
        searchBar.autocapitalizationType = .none
        searchBar.spellCheckingType = .no
       return searchBar
    }()
    
    // MARK: - Init
    
    init(transactions:[Transaction],paymentMethod:PaymentMethod) {
        self.transactions = transactions
        self.originalTransactions = transactions
        self.paymentMethod = paymentMethod
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Transactions"
        view.backgroundColor = .systemBackground
        view.addSubviews(tableView,searchBar,emptyView)
        setupTableView()
        setupSearchBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        emptyView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.width,
            height: view.height-view.safeAreaInsets.top)
    }
    
    // MARK: - Private
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupSearchBar() {
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
    
    private func fetchTransactions(by value:String) {
        guard !value.isEmpty else {
            self.transactions = originalTransactions
            return
        }
        if let transactions = transactionManager.searchTransactions(by: value,
                                                                    paymentMethod: paymentMethod) {
            self.transactions = transactions
        }
    }
    
    private func updateUI() {
        if transactions.isEmpty {
            tableView.isHidden = true
            emptyView.isHidden = false
        } else {
            tableView.isHidden = false
            emptyView.isHidden = true
        }
        tableView.reloadData()
    }

}

  // MARK: - Extension - UITableView

extension TransactionListViewController: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell:TransactionListTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: TransactionListTableViewCell.identifier,
            for: indexPath) as? TransactionListTableViewCell else {
            fatalError()
        }
        let transaction:Transaction = transactions[indexPath.row]
        cell.configure(with: transaction)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Transactions"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        let transaction:Transaction = transactions[indexPath.row]
        let vc:ExpenseDetailedViewController = ExpenseDetailedViewController(transaction: transaction)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension TransactionListViewController:UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchBar.resignFirstResponder()
        }
        fetchTransactions(by: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        fetchTransactions(by: searchBar.text ?? "")
    }
    
}
