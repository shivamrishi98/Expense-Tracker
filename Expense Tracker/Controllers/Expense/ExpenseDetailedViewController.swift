//
//  TransactionDetailedViewController.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 25/03/22.
//

import UIKit

class ExpenseDetailedViewController: UIViewController {

    // MARK: - Properties
    private let transactionManager = TransactionManager()
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
        guard transactionManager.delete(with: transaction.id!) else {
            return
        }
        NotificationCenter.default.post(name: .refreshTransactions,
                                        object: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapEdit() {
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
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ExpenseDetailedTableViewCell.identifier,
            for: indexPath) as? ExpenseDetailedTableViewCell else {
            return UITableViewCell()
        }
        let viewModel = viewModels[indexPath.row]
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
