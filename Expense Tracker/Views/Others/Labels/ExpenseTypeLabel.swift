//
//  ExpenseTypeLabel.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 28/03/22.
//

import UIKit

class ExpenseTypeLabel: UILabel {

    // MARK: - INIT
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Private
    
    private func configureUI() {
        numberOfLines = 1
        textAlignment = .center
        textColor = .white
        font = .systemFont(ofSize: 16,
                           weight: .medium)
    }
    
    
}
