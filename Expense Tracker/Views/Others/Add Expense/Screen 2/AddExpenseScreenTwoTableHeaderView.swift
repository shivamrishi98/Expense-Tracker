//
//  AddExpenseScreenTwoTableHeaderView.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 29/03/22.
//

import UIKit

final class AddExpenseScreenTwoTableHeaderView: UIView {
    
    // MARK: - Properties
    
    private let model: AddExpenseScreenOneModel
  
    // MARK: - UI
    private let titleLabel:TableHeaderViewLabel = TableHeaderViewLabel(fontSize: 18, weight: .bold)
    private let paymentMethodLabel:TableHeaderViewLabel = TableHeaderViewLabel(textColor:.secondaryLabel,fontSize: 16, weight: .semibold)
    private let typeLabel:TableHeaderViewLabel = TableHeaderViewLabel(textColor:.secondaryLabel,fontSize: 16, weight: .semibold)
    private let categoryLabel:TableHeaderViewLabel = TableHeaderViewLabel(textColor:.systemGray2,fontSize: 16, weight: .bold)
    
    // MARK: - Init
    
    init(model: AddExpenseScreenOneModel) {
        self.model = model
        super.init(frame: .zero)
        frame = CGRect(x: 0, y: 0, width: width, height: 130)
        backgroundColor = .systemBackground
        addSubviews(titleLabel,paymentMethodLabel,typeLabel,categoryLabel)
        configureUI(with: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = CGRect(x: 5,
                                  y: 5,
                                  width: width-10,
                                  height: 25)
        paymentMethodLabel.frame = CGRect(x: 5,
                                          y: titleLabel.bottom + 5,
                                          width: width-10,
                                          height: 25)
        typeLabel.frame = CGRect(x: 5,
                                 y: paymentMethodLabel.bottom + 5,
                                 width: width-10,
                                 height: 25)
        categoryLabel.frame = CGRect(x: 5,
                                     y: typeLabel.bottom + 5,
                                     width: width-10,
                                     height: 25)
        
    }
    
    // MARK: - Private
    
    private func configureUI(with model:AddExpenseScreenOneModel) {
        titleLabel.text = model.title
        paymentMethodLabel.text = "Payment Method: \(model.paymentMethod)"
        typeLabel.text = "Type: \(model.type)"
        categoryLabel.text = "Category: \(model.category)"
    }
    
}
