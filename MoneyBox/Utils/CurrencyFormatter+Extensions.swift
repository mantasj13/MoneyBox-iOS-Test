//
//  CurrencyFormatter+Extensions.swift
//  MoneyBox
//
//  Created by Mantas Jakstas on 28/11/23.
//

import Foundation

extension Int {
    func formatAsPounds() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = "GBP"

        return numberFormatter.string(from: NSNumber(value: self)) ?? "n/a"
    }
}

extension Double {
    func formatAsPounds() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = "GBP"

        return numberFormatter.string(from: NSNumber(value: self)) ?? "n/a"
    }
}
