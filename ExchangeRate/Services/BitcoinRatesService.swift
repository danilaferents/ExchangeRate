//
//  BitcoinRatesService.swift
//  ExchangeRate
//
//  Created by Danila Ferentz on 31.08.23.
//

import Foundation

private enum Constants {
    static let twoWeeks: TimeInterval = 1209600
    static let bitcoinRateUrl = "https://api.coingecko.com/api/v3/coins/bitcoin/market_chart"
}

struct BitcoinRate {
    let date: Double
    let price: Double
}

protocol IBitcoinRatesService {
    func fetchRates(currency: String) async throws -> [BitcoinRate]
}

final class BitcoinRatesService: IBitcoinRatesService {
    
    // Properties
    private let defaultSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?
    
    func fetchRates(currency: String) async throws -> [BitcoinRate] {
        
        if let dataTask,
           dataTask.state == .running {
            dataTask.cancel()
        }
        
        let url = Constants.bitcoinRateUrl
        
        let parameters = ["id": "bitcoin",
                          "vs_currency": currency,
                          "days": "14",
                          "interval": "daily",
                          "precision": "3"]

        return try await fetchData(url: url, parameters: parameters)
    }
    
    // MARK: - Private

    private func fetchData(url: String,
                           parameters: [String: String]) async throws -> [BitcoinRate] {
        
        guard var components = URLComponents(string: url) else {
            throw ClientError.noInternet
        }

        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }

        guard let finalUrl = components.url else {
            throw ClientError.invalidRequest
        }
        
        let request = URLRequest(url: finalUrl)
        
        let (data, response) = try await defaultSession.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw ClientError.serverError
        }

        do {
            let finalResponse = try JSONSerialization.jsonObject(with: data)
            if let jsonArray = finalResponse as? [String: Any],
               let arrayRates = jsonArray["prices"] as? [[Double]] {
                return arrayRates.map {
                    return BitcoinRate(date: $0[0] / 1000, price: $0[1])
                }.dropLast().sorted {
                    $0.date > $1.date
                }
            }
        } catch {
            throw ClientError.invalidJsonData(error: error)
        }
        
        return []
    }
}
