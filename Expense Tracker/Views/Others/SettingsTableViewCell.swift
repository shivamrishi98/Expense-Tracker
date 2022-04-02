//
//  SettingsTableViewCell.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 02/04/22.
//

import UIKit

final class SettingsTableViewCell:UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier:String = "SettingsTableViewCell"
    
    // MARK: - UI
    
    private let titleLabel:UILabel = {
       let label = UILabel()
       return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 15,
                                  y: 5,
                                  width: contentView.width-30,
                                  height: contentView.height-10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    // MARK: - Public
    
    public func configure(with title:String) {
        titleLabel.text = title
    }
    
}
