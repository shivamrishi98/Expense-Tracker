//
//  SettingsViewController.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 02/04/22.
//

import UIKit
import UniformTypeIdentifiers

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
                title: "Import/Export",
                options: [
                    SettingsOption(
                        title: "Export to CSV",
                        handler: { [weak self] in
                            self?.exportToCSV()
                        }),
                    SettingsOption(
                        title: "Import from CSV",
                        handler: { [weak self] in
                            self?.importFromCSV()
                        })
                ]),
        ]
    }
    
    private func exportToCSV() {
        let transactions = transactionManager.fetchTransactions()
        let unixTimestamp = Date().timeIntervalSince1970
        let fileName = "expense_\(unixTimestamp).csv"
        
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csvHead = "S.no,Title,Type,Category,Amount,Note,Transaction Date,Created At,Updated At\n"
        
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
            csvHead.append("\(transaction.title!),")
            csvHead.append("\(transaction.type!),")
            csvHead.append("\(transaction.category!),")
            csvHead.append("\(transaction.amount),")
            csvHead.append("\(transaction.note ?? "nil"),")
            csvHead.append("\(transaction.transactionDate!),")
            csvHead.append("\(transaction.createdAt!),")
            csvHead.append("\(transaction.updatedAt!)\n")
        }
            
        do {
            try csvHead.write(to: path!, atomically: true, encoding: .utf8)
            HapticsManager.shared.vibrate(for: .success)
            let exportSheet = UIActivityViewController(activityItems: [path as Any],
                                                       applicationActivities: nil)
            present(exportSheet, animated: true)
        } catch {
            debugPrint(error)
            HapticsManager.shared.vibrate(for: .error)
        }
    }
    
    private func importFromCSV() {
        AlertManager.present(title: "Import",
                             message: "Are you sure you want to import data as that will override current data ?",
                             style: .actionSheet,
                             actions: .yes(
                                handler: { [weak self] in
                                    self?.openDocumentPicker()
                                })
                             ,.dismiss,
                             from: self)
    }
    
    private func openDocumentPicker() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [
            .text,
            .content,
            .item,
            .data
        ])
        documentPicker.delegate = self
        present(documentPicker, animated: true)
    }
    
    private func convert(data:String) -> [[String]]? {
        var result:[[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ",")
            result.append(columns)
        }
        guard rows[0].contains("S.no,Title,Type,Category,Amount,Note,Transaction Date,Created At,Updated At") else {
            HapticsManager.shared.vibrate(for: .error)
            AlertManager.present(title: "Can't Import",
                                 message: "Please add CSV  of this app's transaction format",
                                 actions: .ok,
                                 from: self)
            return nil
        }
        result.removeFirst()
        result.removeLast()
        return result
    }
}

 // MARK: - Extension - UITableView

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
        HapticsManager.shared.vibrateForSelection()
        let option = sections[indexPath.section].options[indexPath.row]
        option.handler()
    }
    
}

// MARK: - Extension - UIDocumentPickerDelegate

extension SettingsViewController:UIDocumentPickerDelegate {

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let filePath = urls.first else {
            return
        }
        if filePath.startAccessingSecurityScopedResource() {
            do {
                let content = try String(contentsOf: filePath,encoding: .utf8)
                let table = convert(data: content)
                if let table = table {
                    transactionManager.deleteAllTransactions()
                    for row in table {
                        let transaction = Transaction(
                            id: UUID(),
                            title: row[1],
                            type: row[2],
                            category: row[3],
                            amount: Double(row[4]) ?? 0.0,
                            note: row[5],
                            transactionDate: Date.formattString(date: row[6]),
                            createdAt: Date.formattString(date: row[7]),
                            updatedAt: Date.formattString(date: row[8]))
                        transactionManager.create(transaction: transaction)
                    }
                    HapticsManager.shared.vibrate(for: .success)
                    AlertManager.present(title: "Imported",
                                         message: "Data Imported",
                                         actions: .ok,
                                         from: self)
                    NotificationCenter.default.post(name: .refreshTransactions,
                                                    object: nil)
                }
            } catch {
                HapticsManager.shared.vibrate(for: .error)
                AlertManager.present(title: "Can't Import",
                                     message: "This format is not supported",
                                     actions: .ok,
                                     from: self)
            }
        }
        filePath.stopAccessingSecurityScopedResource()
    }
}
