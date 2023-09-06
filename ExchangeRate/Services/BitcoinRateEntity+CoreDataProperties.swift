//
//  BitcoinRateEntity+CoreDataProperties.swift
//  ExchangeRate
//
//  Created by Danila Ferentz on 06.09.23.
//
//

import Foundation
import CoreData


extension BitcoinRateEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BitcoinRateEntity> {
        return NSFetchRequest<BitcoinRateEntity>(entityName: "BitcoinRateEntity")
    }

    @NSManaged public var date: Double
    @NSManaged public var price: Double

}

extension BitcoinRateEntity: Identifiable {

}
