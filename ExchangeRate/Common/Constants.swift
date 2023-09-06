//
//  Constants.swift
//  ExchangeRate
//
//  Created by Danila Ferentz on 31.08.23.
//

import UIKit

enum DefaultConstants {
    static let titleFont: UIFont = .systemFont(ofSize: 22)
    static let bodyFont: UIFont = .systemFont(ofSize: 19)
    static let lastUpdateKey: String = "last_update"
    static let bitcoinRateEntity: String = "BitcoinRateEntity"
    static let currencies: [String] = [
        "usd",
        "eur",
        "gbp",
        "rub",
    ]
}
