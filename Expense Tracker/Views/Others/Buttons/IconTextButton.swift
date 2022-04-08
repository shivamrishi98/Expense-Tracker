//
//  IconTextButton.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 08/04/22.
//

import UIKit


protocol IconTextButtonDelegate: AnyObject {
    func iconTextButtonTapped(_ button:IconTextButton)
}

final class IconTextButton:UIButton {

    // MARK: - Properties
    
    struct ViewModel {
        let title:String
        var iconName:String = "chevron.down.circle.fill"
    }

    weak var delegate:IconTextButtonDelegate?
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleColor(.label, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        addTarget(self,
                  action: #selector(didTap),
                  for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycles
    
    override func layoutSubviews() {
        super.layoutSubviews()
        sizeToFit()
        frame = CGRect(x: 0,
                       y: 0,
                       width: width,
                       height: height)
    }
    
    // MARK: - Private
    
    @objc private func didTap() {
        delegate?.iconTextButtonTapped(self)
    }
    
    // MARK: - Public
    
    public func configure(with viewModel:ViewModel) {
        setTitle(viewModel.title, for: .normal)
        setImage(UIImage(systemName: viewModel.iconName), for: .normal)
    }
    
}
