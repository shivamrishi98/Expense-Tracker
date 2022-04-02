//
//  SettingsViewController.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 02/04/22.
//

import UIKit

final class SettingsViewController: UIViewController {

    // MARK: - Properties
    private var sections = [SettingsSection]()
    private let transactionManager = TransactionManager()
    
    // MARK: - UI
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SettingsTableViewCell.self,
                           forCellReuseIdentifier: SettingsTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        configureSections()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - Private
    
    private func configureSections() {
        sections = [
            SettingsSection(
                title: "Share",
                options: [
                    SettingsOption(
                        title: "Export to CSV",
                        handler: { [weak self] in
                            self?.exportToCSV()
                        })
                ])
        ]
    }
    
    private func exportToCSV() {
        let transactions = transactionManager.fetchTransactions()
        let unixTimestamp = Date().timeIntervalSince1970
        let fileName = "expense_\(unixTimestamp).csv"
        
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csvHead = "S.no,Id,Title,Type,Category,Amount,Note,Transaction Date\n"
        
        guard let transactions = transactions,
              !transactions.isEmpty else {
            AlertManager.present(title: "Can't Export",
                                 message: "Add transactions to export",
                                 actions: .ok,
                                 from: self)
            return
        }
        
        for (index,transaction) in transactions.enumerated() {
            csvHead.append("\(index+1),")
            csvHead.append("\(transaction.id!),")
            csvHead.append("\(transaction.title!),")
            csvHead.append("\(transaction.type!),")
            csvHead.append("\(transaction.category!),")
            csvHead.append("\(transaction.amount),")
            csvHead.append("\(transaction.note ?? "nil"),")
            csvHead.append("\(transaction.transactionDate!)\n")
        }
            
        do {
            try csvHead.write(to: path!, atomically: true, encoding: .utf8)
            let exportSheet = UIActivityViewController(activityItems: [path as Any],
                                                       applicationActivities: nil)
            present(exportSheet, animated: true)
        } catch {
            debugPrint(error)
        }
        
    }
}

extension SettingsViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingsTableViewCell.identifier,
            for: indexPath) as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        let option = sections[indexPath.section].options[indexPath.row]
        cell.configure(with: option.title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let option = sections[indexPath.section].options[indexPath.row]
        option.handler()
    }
    
}
