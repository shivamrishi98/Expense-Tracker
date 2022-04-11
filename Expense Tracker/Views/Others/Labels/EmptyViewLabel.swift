//
//  EmptyViewLabel.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 26/03/22.
//

import UIKit

final class EmptyViewLabel: UILabel {

    // MARK: - Properties
    
    enum LabelType {
        case title
        case message
    }
    
    private let type:LabelType
    
    // MARK: - INIT
    
    init(type: LabelType) {
        self.type = type
        super.init(frame: .zero)
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
        switch type {
        case .title:
            textColor = .label
            font = .systemFont(ofSize: 20, weight: .bold)
        case .message:
            textColor = .secondaryLabel
            font = .systemFont(ofSize: 18, weight: .medium)
        }
    }
    
}
