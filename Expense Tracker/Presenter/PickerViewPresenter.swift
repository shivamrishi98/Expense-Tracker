//
//  PickerPresenter.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 08/04/22.
//

import UIKit

protocol PickerViewPresenterDelegate:AnyObject {
    func pickerViewPresenter(didSelect paymentMethod:PaymentMethod)
}

final class PickerViewPresenter: UITextField, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    private let paymentMethods: [PaymentMethod] = PaymentMethod.allCases
    var selectedPaymentMethod: PaymentMethod = .all
    
    weak var pickerDelegate:PickerViewPresenterDelegate?
    
    public var paymentMethod:String {
        return UserDefaults.standard.string(forKey: "payment_method") ?? PaymentMethod.all.title
    }
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    private lazy var doneToolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0,
                                              y: 0,
                                              width: UIScreen.main.bounds.width,
                                              height: 50))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))

        let items = [flexSpace, doneButton]
        toolbar.items = items
        toolbar.sizeToFit()
        return toolbar
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
        setSelectedPaymentMethod()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        inputView = pickerView
        inputAccessoryView = doneToolbar
    }

    @objc private func doneButtonTapped() {
        pickerDelegate?.pickerViewPresenter(didSelect: selectedPaymentMethod)
        resignFirstResponder()
    }

    func showPicker() {
        becomeFirstResponder()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return paymentMethods.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return paymentMethods[row].title
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPaymentMethod = paymentMethods[row]
    }
    
    private func selectRow(for title:String) {
        var row = 0
        switch title {
        case "All":
            row = 0
        case "Cash":
            row = 1
        case "Online":
            row = 2
        default:
            break
        }
        pickerView.selectRow(row,
                             inComponent: 0,
                             animated: true)
    }
    
    private func setSelectedPaymentMethod() {
        switch paymentMethod {
        case PaymentMethod.all.title:
            selectedPaymentMethod = .all
        case PaymentMethod.cash.title:
            selectedPaymentMethod = .cash
        case PaymentMethod.online.title:
            selectedPaymentMethod = .online
        default:
            break
        }
        selectRow(for: paymentMethod)
    }
}
