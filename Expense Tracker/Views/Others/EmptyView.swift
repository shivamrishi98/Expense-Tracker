//
//  EmptyView.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 26/03/22.
//

import UIKit

class EmptyView: UIView {

    // MARK: - Properties
    
    let title:String
    let message:String
    let imageName:String
    
    // MARK: - UI
    
    private let titleLabel:EmptyViewLabel = EmptyViewLabel(type: .title)
    private let messageLabel:EmptyViewLabel = EmptyViewLabel(type: .message)
    
    private let iconImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .label
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    // MARK: - Init
    
    init(title:String = "No Transactions Yet!",
         message:String = "Add a transaction and it will show up here",
         imageName:String = "banknote.fill") {
        self.title = title
        self.message = message
        self.imageName = imageName
        super.init(frame: .zero)
        addSubviews(titleLabel,messageLabel,iconImageView)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize:CGFloat = 100
        iconImageView.frame = CGRect(x: (width-imageSize)/2,
                                     y: 50,
                                     width: imageSize,
                                     height: imageSize)
        titleLabel.frame = CGRect(x: 0,
                                  y: iconImageView.bottom + 50,
                                  width: width,
                                  height: 20)
        messageLabel.frame = CGRect(x: 0,
                                  y: titleLabel.bottom + 10,
                                  width: width,
                                  height: 20)
    }
    
    // MARK: - Private

    private func configure() {
        titleLabel.text = title
        messageLabel.text = message
        iconImageView.image = UIImage(systemName: imageName)
    }
    
    
    
}
