//
//  TablesIntent.swift
//  Database
//
//  Created by Alejandro Bacelis on 23/11/21.
//

import Foundation

extension Tables {
    var intentValue: TableIntent {
        let newTable = TableIntent(identifier: self.objectID.uriRepresentation().absoluteString, display: self.storedItemName ?? self.itemName)
        
        return newTable
    }
}
