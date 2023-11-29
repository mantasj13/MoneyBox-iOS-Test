//
//  LoginError.swift
//  MoneyBox
//
//  Created by Mantas Jakstas on 28/11/23.
//

import Foundation

enum LoginError: Error, CustomStringConvertible {

    case invalidEmail
    case invalidPassword(PasswordError)
    case networkError(Error)

    var description: String {
        switch self {
        case .invalidEmail:
            return "The email address you entered is not valid"
        case let .invalidPassword(passwordError):
            switch passwordError {
            case .empty:
                return "Your password must be at least 10 characters and include one number, one upper case character, and one lower case character"
            case .lowerCaseRequired:
                return "You password must have at least one lower case character"
            case .upperCaseRequired:
                return "You password must have at least one upper case character"
            case .numbersRequired:
                return "Your password must have numbers"
            case .tooShortPassword:
                    return "Your password must have at least 10 characters"
            }

        case let .networkError(error):
            return "\(error.localizedDescription)"
        }
    }
}
