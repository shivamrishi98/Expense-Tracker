//
//  ExpenseTypeCollectionViewCell.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 28/03/22.
//

import UIKit

protocol ExpenseTypeCollectionViewCellDelegate: AnyObject {
    func expenseTypeCollectionViewCell(_ cell:ExpenseTypeCollectionViewCell,
                                       type:ExpenseType)
}

final class ExpenseTypeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier:String = "ExpenseTypeCollectionViewCell"
    
    weak var delegate:ExpenseTypeCollectionViewCellDelegate?
    
    private var expenseType:ExpenseType = .income
    
    // MARK: - UI
    
    let expenseTypeView:ExpenseTypeView = ExpenseTypeView()
    private let typeLabel:ExpenseTypeLabel = ExpenseTypeLabel()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubviews(expenseTypeView)
        expenseTypeView.addSubview(typeLabel)
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(didTapTypeView))
        expenseTypeView.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        expenseTypeView.frame = CGRect(x: 10,
                                       y: 5,
                                       width: contentView.width-20,
                                       height: contentView.height-10)
        
        typeLabel.frame = CGRect(x: 0,
                                 y: 0,
                                 width: expenseTypeView.width,
                                 height: expenseTypeView.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        typeLabel.text = nil
    }
    
    // MARK: - Private
    
    @objc private func didTapTypeView() {
        delegate?.expenseTypeCollectionViewCell(self,
                                                type: expenseType)
    }
    
    // MARK: - Public
    
    public func configure(with type: ExpenseType) {
        self.expenseType = type
        typeLabel.text = type.title
    }
    
}
