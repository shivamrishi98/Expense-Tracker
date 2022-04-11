//
//  ExpenseCategoryCollectionViewCell.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 28/03/22.
//

import UIKit

class ExpenseCategoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier:String = "ExpenseCategoryCollectionViewCell"
    
    override var isSelected: Bool {
       didSet{
           if self.isSelected {
               UIView.animate(withDuration: 0.3) {
                   self.backgroundColor = .link
                   self.iconImageView.tintColor = .white
                   self.categoryTitleLabel.textColor = .white
               }
           }
           else {
               UIView.animate(withDuration: 0.3) {
                   self.backgroundColor = .systemBackground
                   self.iconImageView.tintColor = .systemBlue
                   self.categoryTitleLabel.textColor = .label
               }
           }
       }
   }
    
    // MARK: - UI
    
    private let iconImageView:UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let categoryTitleLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        layer.cornerRadius = 8
        contentView.addSubviews(iconImageView,categoryTitleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize:CGFloat = 50
        iconImageView.frame = CGRect(x: (width-imageSize)/2,
                                     y: ((height-imageSize)/2)-15,
                                     width: imageSize,
                                     height: imageSize)
        categoryTitleLabel.frame = CGRect(x: 5,
                                          y: iconImageView.bottom + 5,
                                          width: contentView.width-10,
                                          height: contentView.height-imageSize-15)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        categoryTitleLabel.text = nil
    }
    
    // MARK: - Public
    
    public func configure(with title:String,iconName:String) {
        iconImageView.image = UIImage(systemName: iconName)
        categoryTitleLabel.text = title
        
    }
    
}
