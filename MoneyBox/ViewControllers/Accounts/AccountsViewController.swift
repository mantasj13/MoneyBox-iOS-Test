//
//  AccountsViewController.swift
//  MoneyBox
//
//  Created by Mantas Jakstas on 28/11/23.
//

import Foundation
import UIKit
import SwiftUI
import Networking

final class AccountsViewController: UIViewController {

    private let userName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let totalPlanValue: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(resource: .bluedark)
        return label
    }()

    private let totalAmountPlanValue: UILabel = {
        let label = UILabel()
        label.text = "£ xxxxxxxxx"
        label.font = UIFont.systemFont(ofSize: 28.0, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(resource: .accent)
        label.heightAnchor.constraint(equalToConstant: 36).isActive = true
        label.widthAnchor.constraint(equalToConstant: 170).isActive = true
        label.isAccessibilityElement = true
        label.accessibilityHint = "This is the total amount of your all plan value accounts"
        return label
    }()

    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Check your personal accounts"
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.gray
        return label
    }()

    private let illustration: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(resource: .illustration)
        return imageView
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor(resource: .background)
        return tableView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style = .large
        activityIndicator.color = UIColor(resource: .accent)
        return activityIndicator
    }()

    weak var coordinator: MainCoordinator?
    private var productsList : [ProductResponse] = []

    let viewModel: AccountsViewModelProtocol
    let refreshControl = UIRefreshControl()

    init(viewModel: AccountsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .background)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        tableView.register(AccountCell.self, forCellReuseIdentifier: "ProductCellIdentifier")

        refreshControl.addTarget(self, action: #selector(refreshTableView(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(resource: .accent)

        layoutConfiguration()
        fetchUserProducts()
        userName.text = "Hello, \(viewModel.user.firstName ?? "N/A") \(viewModel.user.lastName ?? "N/A")"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if coordinator?.needToRefreshAccountsList == true {
            fetchUserProducts()
            coordinator?.needToRefreshAccountsList = false
        }
    }

    @objc func refreshTableView(_ sender: Any) {
        fetchUserProducts()
    }

    private func layoutConfiguration() {

        let labelsStackView = UIStackView(arrangedSubviews: [userName, totalPlanValue, totalAmountPlanValue])
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 5
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(labelsStackView)
        view.addSubview(infoLabel)
        view.addSubview(illustration)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            labelsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),

            illustration.leadingAnchor.constraint(equalTo: labelsStackView.trailingAnchor, constant: 20),
            illustration.centerYAnchor.constraint(equalTo: labelsStackView.centerYAnchor),
            illustration.widthAnchor.constraint(equalToConstant: 130),
            illustration.heightAnchor.constraint(equalToConstant: 100),

            infoLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            infoLabel.topAnchor.constraint(equalTo: labelsStackView.bottomAnchor, constant: 15),

            tableView.topAnchor.constraint(equalTo: labelsStackView.bottomAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func fetchUserProducts() {

        if refreshControl.isRefreshing {
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }

        viewModel.fetchProducts { [weak self] productResponse in
            guard let self else { return }

            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true

            switch productResponse {
            case .success(let response):
                self.totalAmountPlanValue.text = response.totalPlanValue?.formatAsPounds()
                self.productsList = response.productResponses ?? []
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            case .failure(let error):
                if (error as NSError).isTokenExpiredError() {
                    showAlert(title: "Alert", message: "\(error.localizedDescription)") { [weak self] in
                        self?.coordinator?.event(when: .tokenExpired)
                    }
                } else {
                    showAlertRetry(title: "Alert", message: "\(error.localizedDescription)") { [weak self] in
                        self?.fetchUserProducts()
                    }
                }
            }
        }
    }
}

extension AccountsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCellIdentifier", for: indexPath) as! AccountCell
        let product = productsList[indexPath.row]
        cell.setData(
            leftImageURL: product.product?.logoURL,
            planValue: product.planValue,
            moneyboxValue: product.moneybox,
            productTitle: product.product?.friendlyName)
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor(resource: .background)
        cell.configureAccessibility()
        return cell
    }
}

extension AccountsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedProduct = productsList[indexPath.row]
        coordinator?.event(when: .accountSelected(selectedProduct))
    }
}

struct AccountView_Preview: PreviewProvider {
    static var previews: some View {
        AccountsViewController(viewModel: AccountsViewModel(user: User.init(firstName: "Michael", lastName: "Jordan"))).preview
    }
}
