//
//  LoginViewModel.swift
//  MoneyBox
//
//  Created by Mantas Jakstas on 28/11/23.
//

import Foundation
import Networking

protocol LoginViewModelProtocol {
    func login(email: String, password: String, completion: @escaping (Result<User, LoginError>) -> Void)
}

final class LoginViewModel: LoginViewModelProtocol {

    private let provider: DataProviderProtocol
    private let sessionManager: SessionManagerProtocol

    init(provider: DataProviderProtocol = DataProvider(), sessionManager: SessionManagerProtocol = SessionManager()) {
        self.provider = provider
        self.sessionManager = sessionManager
    }

    func validateEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    func validatePassword(password: String) -> Result<Void, PasswordError> {
        guard password.count >= 10 else {
            return .failure(.tooShortPassword)
        }
        guard password.containsNumbers() else {
            return .failure(.numbersRequired)
        }
        guard password.containsLowercase() else {
            return .failure(.lowerCaseRequired)
        }
        guard password.containsUppercase() else {
            return .failure(.upperCaseRequired)
        }
        return .success(())
    }

    func login(email: String, password: String, completion: @escaping (Result<User, LoginError>) -> Void) {

        guard validateEmail(email: email) else {
            completion(.failure(LoginError.invalidEmail))
            return
        }

        if case let .failure(passwordError) = validatePassword(password: password) {
            completion(.failure(LoginError.invalidPassword(passwordError)))
            return
        }

        let request = LoginRequest(email: email, password: password)
        provider.login(request: request) { [weak self] response in
            guard let self else { return }

            switch response {
            case .success(let response):
                self.sessionManager.setUserToken(response.session.bearerToken)
                let user = User(firstName: response.user.firstName, lastName: response.user.lastName)
                completion(.success(user))
            case .failure(let error):
                completion(.failure(.networkError(error)))
            }
        }
    }
}
