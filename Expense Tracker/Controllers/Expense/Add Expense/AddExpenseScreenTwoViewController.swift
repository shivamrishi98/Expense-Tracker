//
//  AddExpenseScreenTwoViewController.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 28/03/22.
//

import UIKit

final class AddExpenseScreenTwoViewController: UIViewController {

    // MARK: - Properties
    
    private let addExpenseScreenOneModel:AddExpenseScreenOneModel
    private var sections:[[AddExpenseScreenTwoFormModel]] = [[AddExpenseScreenTwoFormModel]]()
    private let transactionManager:TransactionManager = TransactionManager()
    private let transaction:Transaction?
    
    // MARK: - UI
    
    private let tableView:UITableView = {
       let tableView = UITableView()
        tableView.register(ExpenseTextfieldTableViewCell.self,
                           forCellReuseIdentifier: ExpenseTextfieldTableViewCell.identifier)
        tableView.register(ExpenseDatePickerTableViewCell.self,
                           forCellReuseIdentifier: ExpenseDatePickerTableViewCell.identifier)
       return tableView
    }()
    
    // MARK: - Init
    
    init(addExpenseScreenOneModel:AddExpenseScreenOneModel, transaction:Transaction?) {
        self.addExpenseScreenOneModel = addExpenseScreenOneModel
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
        setupBarButtonItems()
        setupTableview()
        configureSections()
        fillValuesIfRecordExists()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - Private
    
    private func setupTableview() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableHeaderView = AddExpenseScreenTwoTableHeaderView(
            model: addExpenseScreenOneModel)
    }
    
    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(didTapSave))
    }
    
    @objc private func didTapSave() {
        let screenTwoSectionOneModel:[AddExpenseScreenTwoFormModel] = sections[0]
        let screenTwoSectionTwoModel:[AddExpenseScreenTwoFormModel] = sections[1]
  
        guard let amount:Double = Double(screenTwoSectionOneModel[0].value ?? "")  else {
            HapticsManager.shared.vibrate(for: .error)
            AlertManager.present(title: "Woops",
                                 message: "Please fill the amount",
                                 actions: .ok,
                                 from: self)
            return
        }
        HapticsManager.shared.vibrate(for: .success)
        let transaction:Transaction = Transaction(
            id: transaction?.id ?? UUID(),
            title: addExpenseScreenOneModel.title,
            paymentMethod: addExpenseScreenOneModel.paymentMethod,
            type: addExpenseScreenOneModel.type,
            category: addExpenseScreenOneModel.category,
            amount: amount,
            note: screenTwoSectionOneModel[1].value ?? nil,
            transactionDate: Date.formatString(date: screenTwoSectionTwoModel[0].value ?? ""),
            createdAt: transaction?.createdAt ?? Date(),
            updatedAt: Date())
        UserDefaults.standard.set(addExpenseScreenOneModel.iconName, forKey: addExpenseScreenOneModel.category)

        if let _ = self.transaction {
            if transactionManager.update(transaction: transaction) {
                navigationController?.popToRootViewController(animated: true)
            }
        } else {
            transactionManager.create(transaction: transaction)
            navigationController?.popToRootViewController(animated: true)
        }
        NotificationCenter.default.post(name: .refreshTransactions,
                                        object: nil)
    }
    
    private func configureSections() {
        let sectionOne:[String] = ["Amount","Note"]
        var section1:[AddExpenseScreenTwoFormModel] = [AddExpenseScreenTwoFormModel]()
        for placeholder in sectionOne {
            section1.append(.init(placeholder: placeholder))
        }
        sections.append(section1)
        let sectionTwo:[String] = ["Created on"]
        var section2:[AddExpenseScreenTwoFormModel] = [AddExpenseScreenTwoFormModel]()
        for _ in sectionTwo {
            section2.append(.init(placeholder: ""))
        }
        sections.append(section2)
    }
    
    private func fillValuesIfRecordExists() {
        if let transaction:Transaction = transaction {
            sections[0][0].value = "\(transaction.amount)"
            sections[0][1].value = transaction.note
            sections[1][0].value = String.formattedToOriginal(date: transaction.transactionDate)
        }
    }
}

 // MARK: - Extension - UITableView

extension AddExpenseScreenTwoViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell:ExpenseTextfieldTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: ExpenseTextfieldTableViewCell.identifier,
                for: indexPath) as? ExpenseTextfieldTableViewCell else {
                return UITableViewCell()
            }
            let model:AddExpenseScreenTwoFormModel = sections[indexPath.section][indexPath.row]
            cell.configure(model: model)
            cell.delegate = self
            return cell
        case 1:
            guard let cell:ExpenseDatePickerTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: ExpenseDatePickerTableViewCell.identifier,
                for: indexPath) as? ExpenseDatePickerTableViewCell else {
                return UITableViewCell()
            }
            let model:AddExpenseScreenTwoFormModel = sections[indexPath.section][indexPath.row]
            cell.configure(model: model)
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at:indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return ExpenseTextfieldTableViewCell.rowHeight
        case 1:
            return ExpenseDatePickerTableViewCell.rowHeight
        default:
            return 0
        }
    }
    
}

 // MARK: - Extension - ExpenseTextfieldTableViewCellDelegate

extension AddExpenseScreenTwoViewController:ExpenseTextfieldTableViewCellDelegate {
    
    func expenseTextfieldTableViewCell(_ cell: ExpenseTextfieldTableViewCell,
                                       didUpdateField updatedModel: AddExpenseScreenTwoFormModel) {
        guard let indexPath:IndexPath = tableView.indexPath(for: cell) else {
            return
        }
        sections[indexPath.section][indexPath.row] = updatedModel
        
    }
    
}

// MARK: - Extension - ExpenseDatePickerTableViewCellDelegate

extension AddExpenseScreenTwoViewController:ExpenseDatePickerTableViewCellDelegate {
    
    func expenseDatePickerTableViewCell(_ cell: ExpenseDatePickerTableViewCell,
                                        didUpdateField updatedModel: AddExpenseScreenTwoFormModel) {
        guard let indexPath:IndexPath = tableView.indexPath(for: cell) else {
            return
        }
        sections[indexPath.section][indexPath.row] = updatedModel
    }
    
}
