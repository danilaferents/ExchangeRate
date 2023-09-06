//
//  Configurable.swift
//  ExchangeRate
//
//  Created by Danila Ferentz on 31.08.23.
//

protocol Configurable {
    associatedtype Model
    
    func configure(model: Model)
}
