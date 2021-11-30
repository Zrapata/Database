//
//  WorkspaceIntent.swift
//  Database
//
//  Created by Alejandro Bacelis on 23/11/21.
//

import Foundation

extension WorkSpace {
    static var defaultName: String = "No name"
    
    var intentValue: WorkspaceIntent {
        let newWorkspace = WorkspaceIntent(identifier: self.objectID.uriRepresentation().absoluteString, display: self.itemName)
            
        newWorkspace.projects = self.wrappedProjects.map { $0.intentValue }
        
        return newWorkspace
    }
}
