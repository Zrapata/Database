//
//  ProjectIntent.swift
//  Database
//
//  Created by Alejandro Bacelis on 23/11/21.
//

import Foundation

extension Project {
    var intentValue: ProjectIntent {
        let newProject = ProjectIntent(identifier: self.objectID.uriRepresentation().absoluteString, display: self.storedItemName ?? "No name")
        
        newProject.tables = self.wrappedTables.map { $0.intentValue }
        
        return newProject
    }
}
