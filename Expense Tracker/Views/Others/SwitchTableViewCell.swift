//
//  SwitchTableViewCell.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 03/04/22.
//

import UIKit

protocol SwitchTableViewCellDelegate:AnyObject {
    func switchTableViewCell(_ cell:SwitchTableViewCell,didChange mySwitch:UISwitch)
}

final class SwitchTableViewCell:UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier:String = "SwitchTableViewCell"
    weak var delegate:SwitchTableViewCellDelegate?
    
    // MARK: - UI
    
    private let titleLabel:UILabel = {
       let label = UILabel()
       return label
    }()
    
    private let mySwitch:UISwitch = {
        let mySwitch = UISwitch()
        mySwitch.onTintColor = .systemBlue
        return mySwitch
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .none
        selectionStyle = .none
        contentView.addSubviews(titleLabel,mySwitch)
        mySwitch.addTarget(self,
                           action: #selector(switchValueChanged(_:)),
                           for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.sizeToFit()
        mySwitch.sizeToFit()
        titleLabel.frame = CGRect(x: 15,
                                  y: 5,
                                  width: titleLabel.width,
                                  height: contentView.height-10)
        mySwitch.frame = CGRect(x: titleLabel.right + 10,
                                y: 5,
                                width: mySwitch.width,
                                height: mySwitch.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        mySwitch.isOn = false
    }
    
    // MARK: - Private
    
    @objc private func switchValueChanged(_ sender:UISwitch) {
        delegate?.switchTableViewCell(self,
                                      didChange: sender)
    }
    
    // MARK: - Public
    
    public func configure(with model:SettingsSwitchOption) {
        titleLabel.text = model.title
        mySwitch.isOn = model.isOn
    }
    
}
