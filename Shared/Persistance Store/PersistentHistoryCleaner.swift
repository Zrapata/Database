//
//  PersistentHistoryCleaner.swift
//  Database
//
//  Created by Alejandro Bacelis on 23/11/21.
//

import Foundation
import CoreData

struct PersistentHistoryCleaner {
    let context: NSManagedObjectContext
    let targets: [AppTarget]
    let userDefaults: UserDefaults
    
    func clean() throws {
        guard let timestamp = userDefaults.lastCommonTransactionTimestamp(in: targets) else {
            print("Canceling deletion as there is no common transaction")
            return
        }
        
        let deleteHistoryRequest = NSPersistentHistoryChangeRequest.deleteHistory(before: timestamp)
        print("Deleting persitent history using common timestamp \(timestamp)")
        try context.execute(deleteHistoryRequest)
        
        targets.forEach { target in
            userDefaults.updateLastHistoryTransactionTimestamp(for: target, to: nil)
        }
    }
}
