//
//  IndividualAccountDetailsViewController.swift
//  MoneyBox
//
//  Created by Mantas Jakstas on 28/11/23.
//

import Foundation
import UIKit
import Networking

final class IndividualAccountDetailsViewController: UIViewController {

    private let accountDetailValuePlan: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityHint = "This is the amount of your plan value"

        return label
    }()

    private let moneyBoxValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityHint = "This is the amount of your money box"
        return label
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add £10", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.backgroundColor = UIColor(resource: .accent)
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.widthAnchor.constraint(equalToConstant: 90).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.isAccessibilityElement = true
        button.accessibilityHint = "Tap this button to add money"
        return button
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = UIColor(resource: .accent)
        indicator.style = .large
        return indicator
    }()

    weak var coordinator: MainCoordinator?
    var productResponse: ProductResponse?
    let viewModel: IndividualAccountDetailViewModelProtocol

    init(viewModel: IndividualAccountDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = UIColor(resource: .background)
        navigationItem.title = productResponse?.product?.friendlyName
        accountDetailValuePlan.text = "Plan value: \(productResponse?.planValue?.formatAsPounds() ?? "")"
        moneyBoxValueLabel.text = "Moneybox: \(productResponse?.moneybox?.formatAsPounds() ?? "")"
        layoutConfiguration()
    }

    private func layoutConfiguration() {
        view.addSubview(accountDetailValuePlan)
        view.addSubview(moneyBoxValueLabel)
        view.addSubview(addButton)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            accountDetailValuePlan.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            accountDetailValuePlan.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            moneyBoxValueLabel.topAnchor.constraint(equalTo: accountDetailValuePlan.bottomAnchor, constant: 10),
            moneyBoxValueLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addButton.topAnchor.constraint(equalTo: moneyBoxValueLabel.bottomAnchor, constant: 20),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc func addButtonTapped() {
        addMoney()
    }

    private func addMoney() {

        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false

        viewModel.addTenPounds(productId: productResponse?.id ?? 0) { [weak self] result in
            guard let self else { return }
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true

            switch result {
            case .success(let response):
                view.isUserInteractionEnabled = true
                moneyBoxValueLabel.text = "Money box: \(response.moneybox?.formatAsPounds() ?? "")"
                self.showAlert(
                    title: "Alert",message: "Added money successfully") {
                    self.coordinator?.event(when: .addMoneySuccess)
                }
            case .failure(let error):
                view.isUserInteractionEnabled = true
                if (error as NSError).isTokenExpiredError() {
                    showAlert(title: "Alert", message: "\(error.localizedDescription)") { [weak self] in
                        self?.coordinator?.event(when: .tokenExpired)
                    }
                } else {
                    showAlertRetry(title: "Alert", message: "\(error.localizedDescription)") { [weak self] in
                        self?.addMoney()
                    }
                }
            }
        }
    }
}
