//
//  UserDefaults.swift
//  Database
//
//  Created by Alejandro Bacelis on 23/11/21.
//

import Foundation

extension UserDefaults {
    func lastHistoryTransactionTimestamp(for target: AppTarget) -> Date? {
        let key = Keys.keyForTimeStamp(for: target)
        return object(forKey: key) as? Date
    }
    func updateLastHistoryTransactionTimestamp(for target: AppTarget, to newValue: Date?) {
        let key = Keys.keyForTimeStamp(for: target)
        set(newValue, forKey: key)
    }
    
    func lastCommonTransactionTimestamp(in targets: [AppTarget]) -> Date? {
        let timestamp = targets
            .map { lastHistoryTransactionTimestamp(for: $0) ?? .distantPast }
            .min() ?? .distantPast
        return timestamp > .distantPast ? timestamp : nil
    }
    
    private enum Keys: String {
        case lastHistoryTransactionTimeStamp
        
        static func keyForTimeStamp(for target: AppTarget) -> String {
            "\(lastHistoryTransactionTimeStamp.rawValue)-\(target.rawValue)"
        }
    }
}
