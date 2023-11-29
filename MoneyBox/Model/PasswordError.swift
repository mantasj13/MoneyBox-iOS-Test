//
//  PasswordError.swift
//  MoneyBox
//
//  Created by Mantas Jakstas on 28/11/23.
//

import Foundation

enum PasswordError: Error {
    case empty
    case tooShortPassword
    case numbersRequired
    case lowerCaseRequired
    case upperCaseRequired
}
