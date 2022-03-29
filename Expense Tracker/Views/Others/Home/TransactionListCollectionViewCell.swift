//
//  TransactionListCollectionViewCell.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 29/03/22.
//

import UIKit

final class TransactionListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "TransactionListCollectionViewCell"
    
    // MARK: - UI
    
    private let iconImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .secondarySystemBackground
        imageView.tintColor = .label
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let categoryLabel:UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let totalBalanceLabel:UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let createdAtLabel:UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        contentView.addSubviews(iconImageView,titleLabel,categoryLabel,totalBalanceLabel,createdAtLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = 50
        iconImageView.frame = CGRect(x: 5,
                                     y: (contentView.height-imageSize)/2,
                                     width: imageSize,
                                     height: imageSize)
        titleLabel.sizeToFit()
        categoryLabel.sizeToFit()
        totalBalanceLabel.sizeToFit()
        createdAtLabel.sizeToFit()
        
        titleLabel.frame = CGRect(x: iconImageView.right + 5,
                                  y: (contentView.height-titleLabel.height)/2 - 10,
                                  width: (contentView.width-imageSize-totalBalanceLabel.width-40),
                                  height: titleLabel.height)
        
        totalBalanceLabel.frame = CGRect(x: titleLabel.right + 5,
                                         y: (contentView.height-titleLabel.height)/2 - 10,
                                         width: (contentView.width-imageSize-titleLabel.width-20),
                                         height: totalBalanceLabel.height)
        
        categoryLabel.frame = CGRect(x: iconImageView.right + 5,
                                     y: (contentView.height-titleLabel.height)/2 + 15,
                                     width: (contentView.width-imageSize-createdAtLabel.width-40),
                                     height: categoryLabel.height)
        createdAtLabel.frame = CGRect(x: categoryLabel.right + 5,
                                         y: (contentView.height-categoryLabel.height)/2 + 15,
                                         width: (contentView.width-imageSize-categoryLabel.width-20),
                                         height: totalBalanceLabel.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Public
    
    public func configure() {
        iconImageView.image = UIImage(systemName: "car")
        titleLabel.text = "Title"
        categoryLabel.text = "Transportation"
        totalBalanceLabel.text = "+Rs1234"
        createdAtLabel.text = "Mar 29, 2022"
    }
    
}
