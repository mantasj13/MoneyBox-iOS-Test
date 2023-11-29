//
//  MainCoordinator.swift
//  MoneyBox
//
//  Created by Mantas Jakstas on 28/11/23.
//

import Foundation
import UIKit
import Networking

final class MainCoordinator {

    enum Event {
        case loginRequestSuccess(User)
        case accountSelected(ProductResponse)
        case addMoneySuccess
        case tokenExpired
    }

    let navigationController: UINavigationController
    var needToRefreshAccountsList = false

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func event(when type: Event) {
        switch type {
        case .loginRequestSuccess(let user):
            let accountViewModel = AccountsViewModel(user: user)
            let accountVC = AccountsViewController(viewModel: accountViewModel)
            accountVC.coordinator = self
            navigationController.pushViewController(accountVC, animated: true)
        case .accountSelected(let product):
            let detailViewModel = IndividualAccountDetailViewModel(productResponse: product)
            let detailVC = IndividualAccountDetailsViewController(viewModel: detailViewModel)
            detailVC.productResponse = product
            detailVC.coordinator = self
            navigationController.pushViewController(detailVC, animated: true)
        case .addMoneySuccess:
            needToRefreshAccountsList = true
        case .tokenExpired:
            navigationController.popToRootViewController(animated: false)
        }
    }

    func start() {
        let vc = LoginViewController()
        vc.viewModel = LoginViewModel()
        vc.coordinator = self
        navigationController.setViewControllers([vc], animated: false)
    }
}
