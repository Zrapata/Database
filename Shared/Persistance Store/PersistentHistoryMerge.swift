//
//  PersistentHistoryMerge.swift
//  Database
//
//  Created by Alejandro Bacelis on 23/11/21.
//

import Foundation
import CoreData

struct PersistentHistoryMerge {
    let backgroundContext: NSManagedObjectContext
    let viewContext: NSManagedObjectContext
    let currentTarget: AppTarget
    let userDefaults: UserDefaults
    
    func merge() throws {
        let fromDate = userDefaults.lastHistoryTransactionTimestamp(for: currentTarget) ?? .distantPast
        let fetcher = PersistentHistoryFetcher(context: viewContext, fromDate: fromDate)
        let history = try fetcher.fetch()
        
        guard !history.isEmpty else {
            print("No history trnasactions found to merge for target \(currentTarget.rawValue)")
            return
        }
        
        print("Merging \(history.count) persistent history transactions for target \(currentTarget.rawValue)")
        history.merge(into: self.viewContext)
        
        viewContext.perform {
            history.merge(into: self.viewContext)
        }
        
        guard let lastTimeStamp = history.last?.timestamp else { return }
        userDefaults.updateLastHistoryTransactionTimestamp(for: currentTarget, to: lastTimeStamp)
    }
}

extension Collection where Element == NSPersistentHistoryTransaction {
    func merge(into context: NSManagedObjectContext) {
        forEach { transaction in
            guard let userInfo = transaction.objectIDNotification().userInfo else { return }
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: userInfo, into: [context])
        }
    }
}
