//
//  Project.swift
//  Database
//
//  Created by Alejandro Bacelis on 23/11/21.
//

import Foundation

extension Project {
    var wrappedTables: [Tables] {
        get { tables?.allObjects as? [Tables] ?? [] }
        set { tables = NSSet(array: newValue) }
    }
}
