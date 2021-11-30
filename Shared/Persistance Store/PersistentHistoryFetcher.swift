//
//  PersistentHistoryFetcher.swift
//  Database
//
//  Created by Alejandro Bacelis on 23/11/21.
//

import Foundation
import CoreData

struct PersistentHistoryFetcher {
    
    enum Error: Swift.Error {
        case historyTransactionConvertFail
    }
    
    let context: NSManagedObjectContext
    let fromDate: Date
    
    func fetch() throws -> [NSPersistentHistoryTransaction] {
        let fetchRequest = createFetchRequest()
        
        guard let historyResult = try context.execute(fetchRequest) as? NSPersistentHistoryResult,
              let history = historyResult.result as? [NSPersistentHistoryTransaction] else {
                  throw Error.historyTransactionConvertFail
              }
        return history
    }
    
    func createFetchRequest() -> NSPersistentHistoryChangeRequest {
        let historyFetchRequest = NSPersistentHistoryChangeRequest
            .fetchHistory(after: fromDate)
        
        if let fetchRequest = NSPersistentHistoryTransaction.fetchRequest {
            var predicates = [NSPredicate]()
            
            if let transactionAuthor = context.transactionAuthor {
                predicates.append(NSPredicate(format: "%K != %@", #keyPath(NSPersistentHistoryTransaction.author), transactionAuthor))
            }
            if let contextName = context.name {
                predicates.append(NSPredicate(format: "%K != %@", #keyPath(NSPersistentHistoryTransaction.contextName), contextName))
            }
            
            fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: predicates)
            historyFetchRequest.fetchRequest = fetchRequest
        }
        
        return historyFetchRequest
    }
}
