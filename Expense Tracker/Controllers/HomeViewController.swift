//
//  HomeViewController.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 25/03/22.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private let transactions = [String]()
    
    // MARK: - UI
    
    private let emptyView = EmptyView()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .systemBackground
        setupBarButtonItems()
        view.addSubview(emptyView)
        fetchTransactions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emptyView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.width,
            height: view.height-view.safeAreaInsets.top)
    }
    
    // MARK: - Private
    
    /// Sets up navigation bar button items
    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle"),
            style: .plain,
            target: self,
            action: #selector(didTapAdd))
    }
    
    @objc private func didTapAdd() {
    }
    
    private func fetchTransactions() {
        DispatchQueue.main.async { [weak self] in
            self?.updateUI()
        }
    }
    
    private func updateUI() {
        if transactions.isEmpty {
            emptyView.isHidden = false
        } else {
            emptyView.isHidden = true
        }
    }
}
