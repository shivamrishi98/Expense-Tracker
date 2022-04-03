//
//  HomeHeaderCollectionReusableView.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 29/03/22.
//

import UIKit

final class HomeHeaderCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifier:String = "HomeHeaderCollectionReusableView"
    
    struct ViewModel {
        let balance:Double
        let entries:[String:Double]
    }
   // MARK: - UI
   
    private let totalBalanceNameLabel:UILabel = {
        let label = UILabel()
        label.text = "Total Balance".uppercased()
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private let totalBalanceLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let chartView:ChartView = {
        let chartView = ChartView()
        chartView.backgroundColor = .secondarySystemBackground
        return chartView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        addSubviews(totalBalanceNameLabel,totalBalanceLabel,chartView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        totalBalanceNameLabel.frame = CGRect(x: 10,
                                             y: 5,
                                             width: width-20,
                                             height: 25)
        totalBalanceLabel.frame = CGRect(x: 10,
                                         y: totalBalanceNameLabel.bottom + 5,
                                             width: width-20,
                                             height: 25)
        chartView.frame = CGRect(x: 0,
                                 y: totalBalanceLabel.bottom + 2,
                                 width: width,
                                 height: (height-totalBalanceNameLabel.height-totalBalanceLabel.height-15))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        totalBalanceLabel.text = nil
    }
    
    // MARK: - Public
    
    public func configure(with viewModel: ViewModel) {
        totalBalanceLabel.text = String.formatted(number: viewModel.balance)
        chartView.configure(with: .init(type: nil,
                                        balance: viewModel.balance,
                                        entries: viewModel.entries,
                                        showEntryLabel: false,
                                        showValueLabels: false))
    }
}
