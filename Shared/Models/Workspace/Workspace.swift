//
//  Workspace.swift
//  Database
//
//  Created by Alejandro Bacelis on 23/11/21.
//

import Foundation

extension WorkSpace {
    
    var wrappedProjects: [Project] {
        get { projects?.allObjects as? [Project] ?? [] }
        set { projects = NSSet(array: newValue) }
    }
    
    var lastModifiedAt: Date {
        Date()
    }
}
