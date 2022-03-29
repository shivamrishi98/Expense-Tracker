//
//  BalanceCollectionViewCell.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 29/03/22.
//

import UIKit

final class BalanceCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "BalanceCollectionViewCell"
    
    // MARK: - UI
    
    private let iconImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .label
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let typeLabel:UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private let balanceLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        contentView.addSubviews(iconImageView,typeLabel,balanceLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = 40
        iconImageView.frame = CGRect(x: contentView.width-imageSize-15,
                                     y: 10,
                                     width: imageSize,
                                     height: imageSize)
        typeLabel.sizeToFit()
        balanceLabel.sizeToFit()
        
        typeLabel.frame = CGRect(x: 10,
                                 y: (contentView.width-typeLabel.height)/2,
                                 width: contentView.width-20,
                                 height: typeLabel.height)
        balanceLabel.frame = CGRect(x: 10,
                                    y: typeLabel.bottom + 5,
                                    width: contentView.width-20,
                                    height: balanceLabel.height)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        typeLabel.text = nil
        balanceLabel.text = nil
    }
    
    // MARK: - Public
    
    public func configure() {
        iconImageView.image = UIImage(systemName: "arrow.up.circle")
        typeLabel.text = "Income".uppercased()
        balanceLabel.text = "Rs1234.00"
        iconImageView.tintColor = (typeLabel.text == "INCOME") ? .systemGreen : .systemRed
    }
    
}
