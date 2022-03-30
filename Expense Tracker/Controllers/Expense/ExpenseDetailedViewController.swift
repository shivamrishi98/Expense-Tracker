//
//  TransactionDetailedViewController.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 25/03/22.
//

import UIKit

class ExpenseDetailedViewController: UIViewController {

    // MARK: - Properties
    private let model:String
    
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
    init(model:String) {
        self.model = model
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
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func didTapEdit() {
    }
}

// MARK: - Extension - UITableView

extension ExpenseDetailedViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ExpenseDetailedTableViewCell.identifier,
            for: indexPath) as? ExpenseDetailedTableViewCell else {
            return UITableViewCell()
        }
        cell.configure()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}
