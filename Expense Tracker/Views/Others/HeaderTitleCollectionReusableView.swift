//
//  HeaderTitleCollectionReusableView.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 28/03/22.
//

import UIKit

protocol HeaderTitleCollectionReusableViewDelegate: AnyObject {
    func headerTitleCollectionReusableViewDidTapViewAll(_ cell:HeaderTitleCollectionReusableView)
}

final class HeaderTitleCollectionReusableView: UICollectionReusableView {
 
    // MARK: - Properties
    
    static let identifier:String = "HeaderTitleCollectionReusableView"
    weak var delegate:HeaderTitleCollectionReusableViewDelegate?
    
    // MARK: - UI
 
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 1
        return label
    }()
    
    private let viewAllButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setTitle("View All", for: .normal)
        button.setTitleColor(UIColor.link, for: .normal)
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(titleLabel,viewAllButton)
        viewAllButton.addTarget(self,
                                action: #selector(didTapViewAll),
                                for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewAllButton.sizeToFit()
        titleLabel.frame = CGRect(x: 10,
                                  y: 5,
                                  width: width-viewAllButton.width-25,
                                  height: height-10)
        viewAllButton.frame = CGRect(x: titleLabel.right + 5,
                                     y: 5,
                                     width: viewAllButton.width,
                                     height: viewAllButton.height-5)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    // MARK: - Private
    
    @objc private func didTapViewAll() {
        delegate?.headerTitleCollectionReusableViewDidTapViewAll(self)
    }
    
    // MARK: - Public
    
    public func configure(with title:String,showViewAll:Bool = false) {
        titleLabel.text = title
        if showViewAll {
            viewAllButton.isHidden = false
        } else {
            viewAllButton.isHidden = true
        }
    }
}
