//
//  CoreData+GetItemsFromName.swift
//  Database
//
//  Created by Alejandro Bacelis on 29/11/21.
//

import Foundation
import CoreData

extension Project {
    static func searchByName(_ name: String, in workspace: WorkspaceIDType?, in context: NSManagedObjectContext) -> [Project] {
        var result = [Project]()
        do {
            let projects = try context.fetch(Project.fetchRequest())
            if let workspace = workspace {
                result = projects.filter({ $0.workspace?.objectID.uriRepresentation() == workspace })
            } else {
                result = projects
            }
            
        } catch {
            result = []
        }
        
        return result
    }
    
    static func getAllProjects(in worksapce: WorkspaceIDType?, with context: NSManagedObjectContext) -> [Project] {
        do {
            let projects = try context.fetch(Project.fetchRequest())
            var results = [Project]()
            
            if let worksapce = worksapce {
                results = projects.filter({ $0.workspace?.objectID.uriRepresentation() == worksapce })
            } else {
                results = projects
            }
            return results
        } catch {
            return []
        }
    }
}

extension WorkSpace {
    static func searchByName(_ name: String, in context: NSManagedObjectContext) -> [WorkSpace] {
        do {
            return try context.fetch(WorkSpace.fetchRequest()).filter({ $0.itemName.contains(name) })
        } catch {
            return []
        }
    }
    
    static func getID(name: String, in context: NSManagedObjectContext) -> WorkspaceIDType? {
        Self.searchByName(name, in: context).first?.objectID.uriRepresentation()
    }
    func getID(name: String) -> WorkspaceIDType? {
        Self.getID(name: name, in: self.managedObjectContext!)
    }
}
