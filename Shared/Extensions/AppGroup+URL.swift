//
//  AppGroup+URL.swift
//  Database
//
//  Created by Alejandro Bacelis on 23/11/21.
//

import Foundation

public extension URL {
    static func storeURL(for appGroup: String, with databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created")
        }
        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
