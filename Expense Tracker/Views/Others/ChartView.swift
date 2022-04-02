//
//  ChartView.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 30/03/22.
//

import UIKit
import Charts

final class ChartView:UIView,ChartViewDelegate {
    
    // MARK: - Properties
    
    struct ViewModel {
        let type:String
        let balance:Double
        let entries: [String: Double]
    }
    
    // MARK: - UI
    
    private let chartView:PieChartView = {
        let chartView = PieChartView()
        chartView.isUserInteractionEnabled = false
        chartView.holeRadiusPercent = 0.4
        chartView.transparentCircleRadiusPercent = 0.44
        return chartView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(chartView)
        chartView.delegate = self
        chartView.animate(xAxisDuration: 2, yAxisDuration: 2.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        chartView.frame = bounds
    }
    
    // MARK: - Public
    
    public func configure(with viewModel:ViewModel) {
        var entries:[PieChartDataEntry] = [PieChartDataEntry]()
        
        for (label,value) in viewModel.entries {
            entries.append(.init(value: value, label: label))
        }
        let balance:String = String.formatted(number: viewModel.balance)
        let set:PieChartDataSet = PieChartDataSet(entries: entries, label: "Total \(viewModel.type) = \(balance)")
        set.colors = ChartColorTemplates.colorful()
        set.sliceSpace = 1
        let data:PieChartData = PieChartData(dataSet: set)
        data.setValueFormatter(DefaultValueFormatter(formatter: NumberFormatter.currencyFormatter))
        chartView.data = data
    }
    
}
