//
//  DailyRateModel.swift
//  ExchangeRate
//
//  Created by Danila Ferentz on 31.08.23.
//

import Foundation

struct DailyRateModel: Decodable {
    let date: Date
    let price: Double
    
    init(from: BitcoinRate) {
        self.date = Date.init(timeIntervalSince1970: from.date)
        self.price = from.price
    }
    
    init(from: BitcoinRateEntity) {
        self.date = Date.init(timeIntervalSince1970: from.date)
        self.price = from.price
    }
}
