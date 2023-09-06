//
//  CoreDataManager.swift
//  ExchangeRate
//
//  Created by Danila Ferentz on 01.09.23.
//

import Foundation
import CoreData

enum CoreDataError: Error {
    case unknownState
}

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    private init() {
        container = NSPersistentContainer(name: "ExchangeRate")
        container.loadPersistentStores { description, error in }
        context = container.viewContext
    }
    
    func save() throws {
        try context.save()
    }
    
    func delete(entity: String) throws {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        try context.execute(deleteRequest)
        try save()
    }
    
    func fetch<T: NSFetchRequestResult>(entityName: String) throws -> [T]? {
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        return try self.context.fetch(fetchRequest)
    }
    
    func fetch<T: NSFetchRequestResult>(entityName: String,
                                        descriptor: NSSortDescriptor) throws -> [T]? {
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.sortDescriptors = [descriptor]
        return try self.context.fetch(fetchRequest)
    }
}

protocol RatesDataManager {
    func saveRates(_ rates: [BitcoinRate]) throws
    func getRates() throws -> [BitcoinRateEntity]
}

extension CoreDataManager: RatesDataManager {
    
    func saveRates(_ rates: [BitcoinRate]) throws {
        
        try delete(entity: DefaultConstants.bitcoinRateEntity)
        
        rates.forEach {
            let newRate = BitcoinRateEntity(context: self.context)
            newRate.date = $0.date
            newRate.price = $0.price
        }

        try save()
    }
    
    func getRates() throws -> [BitcoinRateEntity] {
        if let rates: [BitcoinRateEntity] = try self.fetch(entityName: DefaultConstants.bitcoinRateEntity,
                                                           descriptor: NSSortDescriptor(key: "date", ascending: false)) {
            return rates
        }
        
        return []
    }
}
