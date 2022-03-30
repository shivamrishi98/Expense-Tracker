//
//  InputTextField.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 25/03/22.
//

import UIKit

final class InputTextField: UITextField {

    // MARK: - Properties
    
    enum FieldType {
        case title
        case none
        
        var title:String {
            switch self {
            case .title:
                return "Title"
            case .none:
                return ""
            }
        }
    }
    
    private let type:FieldType
    
    // MARK: - INIT
    
    init(type: FieldType) {
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
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 8
        layer.masksToBounds = true
        placeholder = type.title
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: height))
        leftViewMode = .always
        autocorrectionType = .no
        autocapitalizationType = .none
        spellCheckingType = .no
        textColor = .label
    }
    
}
