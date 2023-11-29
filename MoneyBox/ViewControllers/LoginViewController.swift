//
//  LoginViewController.swift
//  MoneyBox
//
//  Created by Mantas Jakstas on 28/11/23.
//

import Foundation
import UIKit
import SwiftUI

final class LoginViewController: UIViewController {

    private let moneyboxImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .moneybox)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        let backgroundColor = UIColor(resource: .accent).withAlphaComponent(0.3)
        textField.backgroundColor = backgroundColor
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isAccessibilityElement = true
        textField.accessibilityHint = "Tap to introduce your email"
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        let backgroundColor = UIColor(resource: .accent).withAlphaComponent(0.3)
        textField.backgroundColor = backgroundColor
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isAccessibilityElement = true
        textField.accessibilityHint = "Tap to introduce the password"
        return textField
    }()

    private lazy var buttonLogin: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        let buttonBackgroundColor = UIColor(resource: .bluedark).withAlphaComponent(0.8)
        button.backgroundColor = buttonBackgroundColor
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.isAccessibilityElement = true
        button.accessibilityHint = "Tap this button if user and password were introduced"
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
    var viewModel: LoginViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .background)
        layoutConfiguration()
    }

    private func layoutConfiguration() {

        view.addSubview(moneyboxImage)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(buttonLogin)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            moneyboxImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            moneyboxImage.widthAnchor.constraint(equalToConstant: 170),
            moneyboxImage.heightAnchor.constraint(equalToConstant: 50),
            moneyboxImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            emailTextField.topAnchor.constraint(equalTo: moneyboxImage.bottomAnchor, constant: 30),
            emailTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),

            buttonLogin.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            buttonLogin.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonLogin.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonLogin.heightAnchor.constraint(equalToConstant: 40),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)

        ])
    }

    @objc func loginButtonTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }

        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false

        viewModel.login(email: email, password: password) { [weak self] loginResult in
            guard let self else { return }

            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true

            view.isUserInteractionEnabled = true
            switch loginResult {
            case let .success(user):
                self.coordinator?.event(when: .loginRequestSuccess(user))
            case let .failure(loginError):
                showAlert(title: "Alert", message: loginError.description)
            }
        }
    }
}

struct MyView_Preview: PreviewProvider {
    static var previews: some View {
        LoginViewController().preview
    }
}
