//
//  String+Extensions.swift
//  MoneyBox
//
//  Created by Mantas Jakstas on 28/11/23.
//

import Foundation

extension String {
    func containsNumbers() -> Bool {
        rangeOfCharacter(from: .decimalDigits) != nil
    }

    func containsUppercase() -> Bool {
        rangeOfCharacter(from: .uppercaseLetters) != nil
    }

    func containsLowercase() -> Bool {
        rangeOfCharacter(from: .lowercaseLetters) != nil
    }
}
