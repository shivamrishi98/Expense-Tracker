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
    private var sections:[SettingsSection] = [SettingsSection]()
    private let transactionManager:TransactionManager = TransactionManager()
    private let biometricsManager = BiometricsManager()
    
    // MARK: - UI
    
    private let tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SettingsTableViewCell.self,
                           forCellReuseIdentifier: SettingsTableViewCell.identifier)
        tableView.register(SwitchTableViewCell.self,
                           forCellReuseIdentifier: SwitchTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var pickerViewPresenter: PickerViewPresenter = {
        let pickerViewPresenter = PickerViewPresenter()
        return pickerViewPresenter
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .systemBackground
        view.addSubviews(tableView,pickerViewPresenter)
        tableView.delegate = self
        tableView.dataSource = self
        pickerViewPresenter.pickerDelegate = self
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
                    .staticCell(
                        model:SettingsOption(
                            title: "Export to CSV",
                            handler: { [weak self] in
                                self?.exportToCSV()
                            })),
                    .staticCell(
                        model:SettingsOption(
                            title: "Import from CSV",
                            handler: { [weak self] in
                                self?.importFromCSV()
                            }))
                ]),
            SettingsSection(
                title: "Default payment method transactions to show",
                options: [
                    .staticCell(
                        model: SettingsOption(
                            title: pickerViewPresenter.paymentMethod,
                            handler: { [weak self] in
                                self?.pickerViewPresenter.showPicker()
                            }))
                ]),
            SettingsSection(
                title: "Theme appearance",
                options: [
                    .switchCell(
                        model:SettingsSwitchOption(
                            title: "Dark Mode:",
                            isOn: UserDefaults.standard.bool(forKey: "dark_mode")))
                ]),
            SettingsSection(
                title: "Security",
                options: [
                    .switchCell(
                        model:SettingsSwitchOption(
                            title: "Biometrics/Passcode:",
                            isOn: UserDefaults.standard.bool(forKey: "bio_metrics")))
                ])
        ]
    }
    
    private func exportToCSV() {
        let transactions:[Transaction]? = transactionManager.fetchTransactions(by: .all)
        
        guard let transactions = transactions,
              !transactions.isEmpty else {
            AlertManager.present(title: "Can't Export",
                                 message: "Add transactions to export",
                                 actions: .ok,
                                 from: self)
            return
        }
        
        let fileName:String = createFileName()
        let path:URL? = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        let csvHead:String = "S.no,Title,Payment Method,Type,Category,Amount,Note,Transaction Date,Created At,Updated At\n"

        let updatedCSV = updateCSVFile(csvHead: csvHead,
                                       transactions: transactions)
        do {
            try updatedCSV.write(to: path!, atomically: true, encoding: .utf8)
            HapticsManager.shared.vibrate(for: .success)
            let exportSheet:UIActivityViewController = UIActivityViewController(activityItems: [path as Any],
                                                       applicationActivities: nil)
            exportSheet.excludedActivityTypes = []
            // Support for ipad
            if let popoverController = exportSheet.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(
                    x: self.view.bounds.midX,
                    y: self.view.bounds.midY,
                    width: 0,
                    height: 0)
                popoverController.permittedArrowDirections = []
            }
            present(exportSheet, animated: true)
        } catch {
            debugPrint(error)
            HapticsManager.shared.vibrate(for: .error)
        }
    }
    
    private func updateCSVFile(csvHead:String,transactions:[Transaction]) -> String {
        var csvFile = csvHead
        for (index,transaction) in transactions.enumerated() {
            csvFile.append("\(index+1),")
            csvFile.append("\(transaction.title),")
            csvFile.append("\(transaction.paymentMethod),")
            csvFile.append("\(transaction.type),")
            csvFile.append("\(transaction.category),")
            csvFile.append("\(transaction.amount),")
            csvFile.append("\(transaction.note ?? "nil"),")
            csvFile.append("\(transaction.transactionDate),")
            csvFile.append("\(transaction.createdAt),")
            csvFile.append("\(transaction.updatedAt)\n")
        }
        return csvFile
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
    
    private func createFileName() -> String {
        let unixTimestamp:TimeInterval = Date().timeIntervalSince1970
        return "expense_\(unixTimestamp).csv"
    }
    
    private func openDocumentPicker() {
        let documentPicker:UIDocumentPickerViewController = UIDocumentPickerViewController(
            forOpeningContentTypes: [
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
        let rows:[String] = data.components(separatedBy: "\n")
        for row in rows {
            let columns:[String] = row.components(separatedBy: ",")
            result.append(columns)
        }
        guard rows[0].contains("S.no,Title,Payment Method,Type,Category,Amount,Note,Transaction Date,Created At,Updated At") else {
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
        
        let optionType:SettingsOptionType = sections[indexPath.section].options[indexPath.row]
        
        switch optionType {
        case .staticCell(let model):
            guard let cell:SettingsTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: SettingsTableViewCell.identifier,
                for: indexPath) as? SettingsTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        case .switchCell(let model):
            guard let cell:SwitchTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: SwitchTableViewCell.identifier,
                for: indexPath) as? SwitchTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.configure(with: model)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let optionType:SettingsOptionType = sections[indexPath.section].options[indexPath.row]
        switch optionType {
        case .staticCell(let model):
            HapticsManager.shared.vibrateForSelection()
            model.handler()
        default:
            break
        }
    }
    
}

// MARK: - Extension - UIDocumentPickerDelegate

extension SettingsViewController:UIDocumentPickerDelegate {

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let filePath:URL = urls.first else {
            return
        }
        if filePath.startAccessingSecurityScopedResource() {
            do {
                let content:String = try String(contentsOf: filePath,encoding: .utf8)
                let table:[[String]]? = convert(data: content)
                if let table = table {
                    transactionManager.deleteAllTransactions()
                    for row in table {
                        let transaction:Transaction = Transaction(
                            id: UUID(),
                            title: row[1],
                            paymentMethod: row[2],
                            type: row[3],
                            category: row[4],
                            amount: Double(row[5]) ?? 0.0,
                            note: row[6],
                            transactionDate: Date.formatString(date: row[7]),
                            createdAt: Date.formatString(date: row[8]),
                            updatedAt: Date.formatString(date: row[9]))
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

// MARK: - Extension - SwitchTableViewCellDelegate

extension SettingsViewController:SwitchTableViewCellDelegate {
    
    func switchTableViewCell(_ cell: SwitchTableViewCell, didChange mySwitch: UISwitch) {
        HapticsManager.shared.vibrate(for: .success)
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        switch indexPath.section {
        case 2:
            UserDefaults.standard.set(mySwitch.isOn, forKey: "dark_mode")
            NotificationCenter.default.post(name: .changeTheme, object: nil)
        case 3:
            guard mySwitch.isOn else {
                mySwitch.setOn(false, animated: true)
                UserDefaults.standard.set(mySwitch.isOn, forKey: "bio_metrics")
                return
            }
            biometricsManager.canEvaluatePolicy { canEvaluate,_, canEvaluateError in
                guard canEvaluate else {
                    AlertManager.present(title: "Woops",
                                         message: canEvaluateError?.errorDescription,
                                         actions: .ok,
                                         from: self)
                    mySwitch.setOn(false, animated: true)
                    return
                }
                mySwitch.setOn(true, animated: true)
                UserDefaults.standard.set(mySwitch.isOn, forKey: "bio_metrics")
            }
        default:
            break
        }
    }
    
}

// MARK: - Extension - SettingsViewController

extension SettingsViewController: PickerViewPresenterDelegate {
    
    func pickerViewPresenter(didSelect paymentMethod: PaymentMethod) {
        HapticsManager.shared.vibrate(for: .success)
        UserDefaults.standard.setValue(paymentMethod.title,
                                       forKey: "payment_method")
        DispatchQueue.main.async { [weak self] in
            self?.configureSections()
            self?.tableView.reloadData()
        }
    }
    
}
