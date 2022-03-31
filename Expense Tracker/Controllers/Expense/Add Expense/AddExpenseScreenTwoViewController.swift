//
//  AddExpenseScreenTwoViewController.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 28/03/22.
//

import UIKit


struct AddExpenseScreenTwoFormModel {
    let placeholder:String
    var value:String?
}

final class AddExpenseScreenTwoViewController: UIViewController {

    // MARK: - Properties
    
    private let addExpenseScreenOneModel:AddExpenseScreenOneModel
    private var sections = [[AddExpenseScreenTwoFormModel]]()
    
    private let transactionManager = TransactionManager()
    
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
    
    init(addExpenseScreenOneModel:AddExpenseScreenOneModel) {
        self.addExpenseScreenOneModel = addExpenseScreenOneModel
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
        setupTableview()
        configureSections()
        setupBarButtonItems()
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
        let screenTwoSectionOneModel = sections[0]
        let screenTwoSectionTwoModel = sections[1]
        let model = Transaction(
            id: UUID(),
            title: addExpenseScreenOneModel.title,
            type: addExpenseScreenOneModel.type,
            category: addExpenseScreenOneModel.category,
            amount: Double(screenTwoSectionOneModel[0].value ?? "") ?? 0.0,
            note: screenTwoSectionOneModel[1].value ?? nil,
            transactionDate: Date.formattString(date: screenTwoSectionTwoModel[0].value ?? ""),
            createdAt: Date(),
            updatedAt: Date())
        UserDefaults.standard.set(addExpenseScreenOneModel.iconName, forKey: addExpenseScreenOneModel.category)
        transactionManager.create(transaction: model)
        NotificationCenter.default.post(name: .refreshTransactions,
                                        object: nil)
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func configureSections() {
        let sectionOne = ["Amount","Note"]
        var section1 = [AddExpenseScreenTwoFormModel]()
        for placeholder in sectionOne {
            section1.append(.init(placeholder: placeholder))
        }
        sections.append(section1)
        let sectionTwo = ["Created on"]
        var section2 = [AddExpenseScreenTwoFormModel]()
        for _ in sectionTwo {
            section2.append(.init(placeholder: ""))
        }
        sections.append(section2)
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
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ExpenseTextfieldTableViewCell.identifier,
                for: indexPath) as? ExpenseTextfieldTableViewCell else {
                return UITableViewCell()
            }
            let model = sections[indexPath.section][indexPath.row]
            cell.configure(model: model)
            cell.delegate = self
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ExpenseDatePickerTableViewCell.identifier,
                for: indexPath) as? ExpenseDatePickerTableViewCell else {
                return UITableViewCell()
            }
            let model = sections[indexPath.section][indexPath.row]
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
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        sections[indexPath.section][indexPath.row] = updatedModel
        
    }
    
}

// MARK: - Extension - ExpenseDatePickerTableViewCellDelegate

extension AddExpenseScreenTwoViewController:ExpenseDatePickerTableViewCellDelegate {
    
    func expenseDatePickerTableViewCell(_ cell: ExpenseDatePickerTableViewCell,
                                        didUpdateField updatedModel: AddExpenseScreenTwoFormModel) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        sections[indexPath.section][indexPath.row] = updatedModel
    }
    
}
