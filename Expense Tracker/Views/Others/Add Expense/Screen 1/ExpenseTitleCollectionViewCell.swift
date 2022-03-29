//
//  ExpenseTitleCollectionViewCell.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 28/03/22.
//

import UIKit

protocol ExpenseTextfieldCollectionViewCellDelegate:AnyObject {
    func expenseTextfieldCollectionViewCell(_ cell:ExpenseTextfieldCollectionViewCell,
                                        didUpdateField title:String)
}

final class ExpenseTextfieldCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "ExpenseTitleCollectionViewCell"
    weak var delegate:ExpenseTextfieldCollectionViewCellDelegate?
    private var title:String?
    
    // MARK: - UI
    
    private let titleTextfield = InputTextField(type: .title)
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleTextfield)
        titleTextfield.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleTextfield.frame = CGRect(x: 10,
                                      y: 1,
                                      width: contentView.width-20,
                                      height: 44)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleTextfield.text = nil
        titleTextfield.placeholder = InputTextField.FieldType.title.title
    }
    
    // MARK: - Public
    
    public func configure(with title:String) {
        self.title = title
        titleTextfield.text = title
    }
    
}

 // MARK: - Extension - UITextField

extension ExpenseTextfieldCollectionViewCell:UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        title = textField.text
        guard let title = title else {
            return true
        }
        delegate?.expenseTextfieldCollectionViewCell(self,
                                                 didUpdateField: title)
        textField.resignFirstResponder()
        return true
    }
}
