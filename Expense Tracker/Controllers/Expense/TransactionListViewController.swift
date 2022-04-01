//
//  TransactionListViewController.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 30/03/22.
//

import UIKit

class TransactionListViewController: UIViewController {

    // MARK: - Properties
    
    private let transactions:[Transaction]
    
    // MARK: - UI
    
    private let tableView:UITableView = {
       let tableView = UITableView()
        tableView.register(TransactionListTableViewCell.self,
                           forCellReuseIdentifier: TransactionListTableViewCell.identifier)
       return tableView
    }()
    
    // MARK: - Init
    
    init(transactions:[Transaction]) {
        self.transactions = transactions
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
        view.addSubviews(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
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
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TransactionListTableViewCell.identifier,
            for: indexPath) as? TransactionListTableViewCell else {
            fatalError()
        }
        let transaction = transactions[indexPath.row]
        cell.configure(with: transaction)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "March"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        let transaction = transactions[indexPath.row]
        let vc = ExpenseDetailedViewController(transaction: transaction)
        navigationController?.pushViewController(vc, animated: true)
    }
}
