//
//  TableHeaderViewLabel.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 29/03/22.
//

import UIKit

final class TableHeaderViewLabel: UILabel {

    // MARK: - INIT
   
    init(textColor:UIColor = .label,
         fontSize:CGFloat,
         weight:UIFont.Weight
    ) {
        super.init(frame: .zero)
        configureUI(textColor: textColor,
                    fontSize: fontSize,
                    weight: weight)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Private
    
    private func configureUI(textColor:UIColor,
                             fontSize:CGFloat,
                             weight:UIFont.Weight) {
        numberOfLines = 1
        textAlignment = .left
        self.textColor = textColor
        font = .systemFont(ofSize: fontSize,
                           weight: weight)
    }
    
    
}

