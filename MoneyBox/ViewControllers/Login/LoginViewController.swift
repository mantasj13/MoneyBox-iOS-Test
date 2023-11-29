//
//  LoginViewController.swift
//  MoneyBox
//
//  Created by Mantas Jakstas on 25/11/23.
//

import Foundation
import UIKit
import SwiftUI

final class LoginViewController: UIViewController {

    private let imageLogo = UIImageView()
    private let userName = UITextField()
    private let password = UITextField()
    private let buttonLogin = UIButton()
    private let activityIndicator = UIActivityIndicatorView()

    weak var coordinator: MainCoordinator?
    var viewModel: LoginViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .background)
        configure()
        layoutConstrains()
    }

    func configure() {

        imageLogo.image = UIImage(resource: .moneybox)
        imageLogo.contentMode = .scaleAspectFit
        imageLogo.translatesAutoresizingMaskIntoConstraints = false

        userName.placeholder = "Username"
        userName.text = "test+ios2@moneyboxapp.com"
        let backgroundColor = UIColor(resource: .accent).withAlphaComponent(0.3)
        userName.backgroundColor = backgroundColor
        userName.borderStyle = .roundedRect
        userName.translatesAutoresizingMaskIntoConstraints = false

        password.placeholder = "Password"
        password.text = "P455word12"
        password.backgroundColor = backgroundColor
        password.isSecureTextEntry = true
        password.borderStyle = .roundedRect
        password.translatesAutoresizingMaskIntoConstraints = false

        buttonLogin.setTitle("Login", for: .normal)
        buttonLogin.setTitleColor(.white, for: .normal)
        buttonLogin.translatesAutoresizingMaskIntoConstraints = false
        let buttonBackgroundColor = UIColor(resource: .bluedark).withAlphaComponent(0.8)
        buttonLogin.backgroundColor = buttonBackgroundColor
        buttonLogin.layer.cornerRadius = 8
        buttonLogin.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = UIColor(resource: .accent)
        activityIndicator.style = .large
    }

    func layoutConstrains() {

        view.addSubview(imageLogo)
        view.addSubview(userName)
        view.addSubview(password)
        view.addSubview(buttonLogin)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            imageLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageLogo.widthAnchor.constraint(equalToConstant: 170),
            imageLogo.heightAnchor.constraint(equalToConstant: 55),
            imageLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            userName.topAnchor.constraint(equalTo: imageLogo.bottomAnchor, constant: 30),
            userName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            userName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            userName.heightAnchor.constraint(equalToConstant: 40),

            password.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 20),
            password.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            password.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            password.heightAnchor.constraint(equalToConstant: 40),

            buttonLogin.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 20),
            buttonLogin.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonLogin.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonLogin.heightAnchor.constraint(equalToConstant: 40),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)

        ])
    }

    @objc func loginButtonTapped() {
        login()
    }

    func login() {
        guard let email = userName.text, let password = password.text else { return }

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
                self.coordinator?.eventOccurred(with: .loginRequestSuccess(user))
            case let .failure(loginError):
                self.showAlert(title: "Alert", message: "\(loginError.description)")
            }
        }
    }
}

struct MyView_Preview: PreviewProvider {
    static var previews: some View {
        LoginViewController().preview
    }
}
