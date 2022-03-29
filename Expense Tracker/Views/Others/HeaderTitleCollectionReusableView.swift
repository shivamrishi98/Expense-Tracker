//
//  HeaderTitleCollectionReusableView.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 28/03/22.
//

import UIKit

final class HeaderTitleCollectionReusableView: UICollectionReusableView {
 
    // MARK: - Properties
    
    static let identifier = "HeaderTitleCollectionReusableView"
    
    // MARK: - UI
 
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 1
        return label
    }()
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = CGRect(x: 10,
                                  y: 5,
                                  width: width-20,
                                  height: height-10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Public
    
    public func configure(with title:String) {
        titleLabel.text = title
    }
}
