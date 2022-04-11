//
//  ExpenseTypeView.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 28/03/22.
//

import Foundation
import UIKit

final class ExpenseTypeView: UIView {

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Private
    
    private func configureUI() {
        clipsToBounds = true
        layer.masksToBounds = true
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondaryLabel.cgColor
    }
    
}
