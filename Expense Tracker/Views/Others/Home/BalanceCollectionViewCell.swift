//
//  BalanceCollectionViewCell.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 29/03/22.
//

import UIKit

final class BalanceCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier:String = "BalanceCollectionViewCell"
    
    struct ViewModel {
        let type:ExpenseType
        let balance:Double
    }
    
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

        balanceLabel.frame = CGRect(x: 10,
                                    y: contentView.height-balanceLabel.height-5,
                                    width: contentView.width-20,
                                    height: balanceLabel.height)
        
        typeLabel.frame = CGRect(x: 10,
                                 y: balanceLabel.top - typeLabel.height - 5,
                                 width: contentView.width-20,
                                 height: typeLabel.height)

        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        typeLabel.text = nil
        balanceLabel.text = nil
    }
    
    // MARK: - Public
    
    public func configure(with viewModel:ViewModel) {
        let expenseType:Bool = (viewModel.type.title == ExpenseType.expense.title)
        iconImageView.tintColor = expenseType ? .systemRed : .systemGreen
        iconImageView.image = viewModel.type == .income ? UIImage(systemName: "arrow.up.circle") : UIImage(systemName: "arrow.down.circle")
        typeLabel.text = viewModel.type.title.uppercased()
        balanceLabel.text = String.formatted(number: viewModel.balance)
    }
    
}
