//
//  TransactionListViewController.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 25/03/22.
//

import UIKit

final class TransactionExpenseTypeListViewController: UIViewController {

    // MARK: - Properties
    
    private let type:ExpenseTypeCollectionViewCell.ExpenseType
    
    // MARK: - UI
    
    private let chartView = ChartView()
    
    private let tableView:UITableView = {
       let tableView = UITableView()
        tableView.register(TransactionListTableViewCell.self,
                           forCellReuseIdentifier: TransactionListTableViewCell.identifier)
       return tableView
    }()
    
    // MARK: - Init
    
    init(type:ExpenseTypeCollectionViewCell.ExpenseType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = type.title
        view.backgroundColor = .systemBackground
        view.addSubviews(tableView,chartView)
        tableView.dataSource = self
        tableView.delegate = self
        chartView.backgroundColor = .systemOrange
        tableView.tableHeaderView = chartView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
        chartView.frame = CGRect(x: 0,
                                 y: view.safeAreaInsets.top,
                                 width: view.width,
                                 height: 350)
    }
    

}

  // MARK: - Extension - UITableView

extension TransactionExpenseTypeListViewController: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TransactionListTableViewCell.identifier,
            for: indexPath) as? TransactionListTableViewCell else {
            fatalError()
        }
        cell.configure()
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
    }
}
