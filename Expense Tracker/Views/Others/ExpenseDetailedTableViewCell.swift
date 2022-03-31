//
//  ExpenseDetailedTableViewCell.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 30/03/22.
//

import UIKit

final class ExpenseDetailedTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    static let identifier = "ExpenseDetailedTableViewCell"
    
    struct ViewModel {
        let name:String
        let value:String?
    }
    
    // MARK: - UI
    
    private let nameLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let valueLabel:UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .secondarySystemBackground
        contentView.addSubviews(nameLabel,valueLabel)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.sizeToFit()
        valueLabel.sizeToFit()
        nameLabel.frame = CGRect(x: 15,
                                 y: 10,
                                 width: contentView.width-30,
                                 height: nameLabel.height)
        valueLabel.frame = CGRect(x: 15,
                                  y: nameLabel.bottom + 10,
                                  width: contentView.width-30,
                                  height: valueLabel.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        valueLabel.text = nil
    }
    
    // MARK: - Public
    
    public func configure(with viewModel:ViewModel) {
        nameLabel.text = viewModel.name
        valueLabel.text = viewModel.value ?? "nil"
    }
    

}
