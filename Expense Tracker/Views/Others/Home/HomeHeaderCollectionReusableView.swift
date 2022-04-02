//
//  HomeHeaderCollectionReusableView.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 29/03/22.
//

import UIKit

final class HomeHeaderCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifier:String = "HomeHeaderCollectionReusableView"
    
   // MARK: - UI
   
    private let totalBalanceNameLabel:UILabel = {
        let label = UILabel()
        label.text = "Total Balance".uppercased()
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private let totalBalanceLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(totalBalanceNameLabel,totalBalanceLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        totalBalanceNameLabel.frame = CGRect(x: 10,
                                             y: 15,
                                             width: width-20,
                                             height: 25)
        totalBalanceLabel.frame = CGRect(x: 10,
                                         y: totalBalanceNameLabel.bottom + 5,
                                             width: width-20,
                                             height: 25)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        totalBalanceLabel.text = nil
    }
    
    // MARK: - Public
    
    public func configure(with balance: Double) {
        totalBalanceLabel.text = String.formatted(number: balance)
    }
    
}
