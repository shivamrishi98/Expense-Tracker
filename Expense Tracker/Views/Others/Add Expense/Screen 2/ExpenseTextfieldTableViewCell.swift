//
//  ExpenseTextfieldTableViewCell.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 29/03/22.
//

import UIKit

protocol ExpenseTextfieldTableViewCellDelegate: AnyObject {
    func expenseTextfieldTableViewCell(_ cell:ExpenseTextfieldTableViewCell,
                                          didUpdateField updatedModel: AddExpenseScreenTwoFormModel)
}

class ExpenseTextfieldTableViewCell:UITableViewCell,UITextFieldDelegate {
    
    // MARK: - Properties
    
    static let identifier = "ExpenseTextfieldTableViewCell"
    static let rowHeight:CGFloat = 50
    public weak var delegate:ExpenseTextfieldTableViewCellDelegate?
    private var model:AddExpenseScreenTwoFormModel?
    
    // MARK: - UI
    
    private var textfield = InputTextField(type: .none)
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textfield)
        textfield.delegate = self
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textfield.frame = CGRect(x: 10,
                                 y: 1,
                                 width: contentView.width-20,
                                 height: 44)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textfield.placeholder = nil
        textfield.text = nil
    }
    
    // MARK: - UITextfieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        model?.value = textField.text
        guard let model = model else {
            return true
        }
        delegate?.expenseTextfieldTableViewCell(self,
                                                didUpdateField: model)
        textfield.resignFirstResponder()
        return true
    }
    
    // MARK: - Private
    
    @objc private func didTapKeyboardDone() {
        model?.value = textfield.text
        guard let model = model else {
            return
        }
        delegate?.expenseTextfieldTableViewCell(self,
                                                didUpdateField: model)
        textfield.resignFirstResponder()
    }
    
    // MARK: - Public
    
    public func configure(model: AddExpenseScreenTwoFormModel) {
        self.model = model
        textfield.placeholder = model.placeholder
        textfield.text = model.value
        textfield.keyboardType = (model.placeholder == "Amount") ? .decimalPad : .default
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: contentView.width, height: 50))
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapKeyboardDone))
        ]
        toolBar.sizeToFit()
        textfield.inputAccessoryView = (model.placeholder == "Amount") ? toolBar : nil
    }
    
}
