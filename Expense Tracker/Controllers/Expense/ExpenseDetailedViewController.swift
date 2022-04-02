//
//  TransactionDetailedViewController.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 25/03/22.
//

import UIKit

class ExpenseDetailedViewController: UIViewController {

    // MARK: - Properties
    private let transactionManager:TransactionManager = TransactionManager()
    private let transaction:Transaction
    private var viewModels = [ExpenseDetailedTableViewCell.ViewModel]()
    
    // MARK: - UI
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .secondarySystemBackground
        tableView.separatorStyle = .none
        tableView.register(ExpenseDetailedTableViewCell.self,
                           forCellReuseIdentifier: ExpenseDetailedTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - Init
    init(transaction:Transaction) {
        self.transaction = transaction
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"
        view.backgroundColor = .systemBackground
        setupBarButtonItems()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        createViewModels()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - Private
    
    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItems  = [
            UIBarButtonItem(barButtonSystemItem: .trash,
                            target: self,
                            action: #selector(didTapDelete)),
            UIBarButtonItem(barButtonSystemItem: .edit,
                            target: self,
                            action: #selector(didTapEdit))
        ]
    }
    
    @objc private func didTapDelete() {
        AlertManager.present(
            title: "Delete Transaction",
            message: "Are you sure you want to delete this transaction?",
            style: .actionSheet,
            actions: .delete(
                handler: { [weak self] in
                    guard let strongSelf = self,
                          strongSelf.transactionManager.delete(with: strongSelf.transaction.id!)  else {
                        HapticsManager.shared.vibrate(for: .error)
                        return
                    }
                    HapticsManager.shared.vibrate(for: .success)
                    NotificationCenter.default.post(name: .refreshTransactions,
                                                    object: nil)
                    self?.navigationController?.popToRootViewController(animated: true)
                }), .dismiss,
            from: self)
        
    }
    
    @objc private func didTapEdit() {
        let vc:AddExpenseScreenOneViewController = AddExpenseScreenOneViewController(transaction: transaction)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func createViewModels() {
        viewModels.append(.init(name: "Title", value: transaction.title))
        viewModels.append(.init(name: "Type", value: transaction.type))
        viewModels.append(.init(name: "Category", value: transaction.category))
        viewModels.append(.init(name: "Amount", value: String.formatted(number: transaction.amount)))
        viewModels.append(.init(name: "Note", value: transaction.note))
        viewModels.append(.init(name: "Transaction Date",
                                value: String.formatted(date: transaction.transactionDate ?? Date())))
    }
}

// MARK: - Extension - UITableView

extension ExpenseDetailedViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell:ExpenseDetailedTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: ExpenseDetailedTableViewCell.identifier,
            for: indexPath) as? ExpenseDetailedTableViewCell else {
            return UITableViewCell()
        }
        let viewModel:ExpenseDetailedTableViewCell.ViewModel = viewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}
