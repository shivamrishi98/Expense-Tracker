//
//  ExpenseDatePickerTableViewCell.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 29/03/22.
//

import UIKit

protocol ExpenseDatePickerTableViewCellDelegate: AnyObject {
    func expenseDatePickerTableViewCell(_ cell:ExpenseDatePickerTableViewCell,
                                          didUpdateField updatedModel: AddExpenseScreenTwoFormModel)
}



final class ExpenseDatePickerTableViewCell:UITableViewCell {
    
    static let identifier:String = "ExpenseDatePickerTableViewCell"
    static let rowHeight:CGFloat = 50
    
    public weak var delegate:ExpenseDatePickerTableViewCellDelegate?
    
    private var model:AddExpenseScreenTwoFormModel?
    
    private let datePicker:UIDatePicker = {
        let picker = UIDatePicker()
        return picker
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(datePicker)
        selectionStyle = .none
        datePicker.addTarget(self,
                             action: #selector(didChangeValue(_:)), for: .valueChanged)
    }
    
    @objc private func didChangeValue(_ picker:UIDatePicker) {
        model?.value = String.formattedToOriginal(date: picker.date)
        guard let model = model else {
            return
        }
        delegate?.expenseDatePickerTableViewCell(self,
                                                   didUpdateField: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        datePicker.frame = CGRect(x: 10,
                                 y: 1,
                                 width: contentView.width-20,
                                 height: contentView.height-2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
        
    
    public func configure(model: AddExpenseScreenTwoFormModel) {
        self.model = model
        datePicker.date = Date.formatString(date: model.value ?? "")
    }
    
}
