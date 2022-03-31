//
//  ExpenseCategoryCollectionViewCell.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 28/03/22.
//

import UIKit

class ExpenseCategoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "ExpenseCategoryCollectionViewCell"
    
    enum Category {
        enum Income: CaseIterable  {
            case salary
            case refunds
            case rental
            case dividends
            case others
            case none
            
            var title:String {
                switch self {
                case .salary:
                    return "Salary"
                case .refunds:
                    return "Refunds"
                case .rental:
                    return "Rental"
                case .dividends:
                    return "Dividends"
                case .others:
                    return "Others"
                case .none:
                    return ""
                }
            }
            
            var iconName:String {
                switch self {
                case .salary:
                    return "wallet.pass"
                case .refunds:
                    return "arrow.triangle.2.circlepath.circle"
                case .rental:
                    return "house.circle"
                case .dividends:
                    return "chart.xyaxis.line"
                case .others:
                    return "square.grid.2x2"
                case .none:
                    return ""
                }
            }
        }
        enum Expense: CaseIterable  {
            case transportation
            case food
            case bills
            case entertainment
            case shopping
            case insurance
            case tax
            case cigarette
            case health
            case sport
            case baby
            case pet
            case beauty
            case electronics
            case alcohol
            case grocery
            case gift
            case education
            case others
            case none
            
            var title:String {
                switch self {
                case .transportation:
                    return "Transportation"
                case .food:
                    return "Food"
                case .bills:
                    return "Bills"
                case .entertainment:
                    return "Entertainment"
                case .shopping:
                    return "Shopping"
                case .insurance:
                    return "Insurance"
                case .tax:
                    return "Tax"
                case .cigarette:
                    return "Cigarette"
                case .health:
                    return "Health"
                case .sport:
                    return "Sports"
                case .baby:
                    return "Baby"
                case .pet:
                    return "Pet"
                case .beauty:
                    return "Beauty"
                case .electronics:
                    return "Electronics"
                case .alcohol:
                    return "Alcohol"
                case .grocery:
                    return "Grocery"
                case .gift:
                    return "Gift"
                case .education:
                    return "Education"
                case .others:
                    return "Others"
                case .none:
                    return ""
                }
            }
            
            var iconName:String {
                switch self {
                case .transportation:
                    return "bus"
                case .food:
                    return "fork.knife.circle"
                case .bills:
                    return "person.circle"
                case .entertainment:
                    return "gamecontroller"
                case .shopping:
                    return "bag.circle"
                case .insurance:
                    return "checkmark.shield"
                case .tax:
                    return "newspaper.circle"
                case .cigarette:
                    return "pencil.circle"
                case .health:
                    return "heart.text.square"
                case .sport:
                    return "sportscourt"
                case .baby:
                    return "bed.double.circle"
                case .pet:
                    return "person.circle"
                case .beauty:
                    return "person.circle"
                case .electronics:
                    return "person.circle"
                case .alcohol:
                    return "person.circle"
                case .grocery:
                    return "person.circle"
                case .gift:
                    return "person.circle"
                case .education:
                    return "person.circle"
                case .others:
                    return "person.circle"
                case .none:
                    return ""
                }
            }
        }
    }

    
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
    
    private let iconImageView: UIImageView = {
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
