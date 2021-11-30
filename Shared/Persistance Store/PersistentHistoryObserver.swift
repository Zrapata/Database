//
//  PersistentHistoryObserver.swift
//  Database
//
//  Created by Alejandro Bacelis on 23/11/21.
//

import Foundation
import CoreData

public final class PersistentHistoryObserver {
    private let target: AppTarget
    private let userDefaults: UserDefaults
    private let persistentContainer: NSPersistentCloudKitContainer
    
    private lazy var hirtoryQueue: OperationQueue = {
       let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    public init(target: AppTarget, persistentContainer: NSPersistentCloudKitContainer, userDefaults: UserDefaults) {
        self.target = target
        self.persistentContainer = persistentContainer
        self.userDefaults = userDefaults
    }
    
    public func startObserving() {
        NotificationCenter.default.addObserver(self, selector: #selector(processStoreRemoteChanges), name: .NSPersistentStoreRemoteChange, object: persistentContainer.persistentStoreCoordinator)
    }
    
    @objc private func processStoreRemoteChanges(_ notification: Notification) {
        hirtoryQueue.addOperation { [weak self] in
            self?.processPerisntentHistory()
        }
    }
    
    @objc private func processPerisntentHistory() {
        let context = persistentContainer.newBackgroundContext()
        context.performAndWait {
            do {
                let merger = PersistentHistoryMerge(backgroundContext: context, viewContext: persistentContainer.viewContext, currentTarget: target, userDefaults: userDefaults)
                try merger.merge()
                
                let cleaner = PersistentHistoryCleaner(context: context, targets: AppTarget.allCases, userDefaults: userDefaults)
                try cleaner.clean()
            } catch {
                print("Persistent History Tracking with error \(error)")
            }
        }
    }
}
