//
//  ClientError.swift
//  ExchangeRate
//
//  Created by Danila Ferentz on 31.08.23.
//

import Foundation

enum ClientError : Error {
    case noInternet
    case serverError
    case invalidRequest
    case invalidJsonData(error: Error)
    case unknownError
    case invalidResponse

    var text : String {
        switch self {
        case .noInternet:
            return "Looks like you have lost the internet connection."
        case .invalidRequest:
            return "Seems there was something wrong with the request."
        case .serverError:
            return "Unexpected error encountered. Please try again later."
        case .invalidJsonData(let error):
            return "Invalid json data with error :- \(error)."
        case .invalidResponse:
            return "Recieved unexpected answer. Please try again."
        case .unknownError:
            return "Unknown error"
        }
    }
}
