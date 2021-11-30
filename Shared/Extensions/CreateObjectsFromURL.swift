//
//  CreateObjectsFromURL.swift
//  Database
//
//  Created by Alejandro Bacelis on 25/11/21.
//

import SwiftUI
import CoreData

extension WorkSpace {
    static func fetchObject(from url: URL, using context: NSManagedObjectContext) -> WorkSpace? {
        if let id = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: url) {
            return context.object(with: id) as? WorkSpace
        }
        return nil
    }
}
extension Project {
    static func fetchObject(from url: URL, using context: NSManagedObjectContext) -> Project? {
        if let id = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: url) {
            return context.object(with: id) as? Project
        }
        return nil
    }
}
extension FieldItem {
    static func fetchObject(from url: URL, using context: NSManagedObjectContext) -> Self? {
        if let id = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: url) {
            return context.object(with: id) as? Self
        }
        return nil
    }
}
extension Tables {
    static func fetchObject(from url: URL, using context: NSManagedObjectContext) -> Tables? {
        if let id = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: url) {
            return context.object(with: id) as? Tables
        }
        return nil
    }
    
    static func bindingObject(from url: URL, using context: NSManagedObjectContext) -> Binding<Tables>? {
        if let table = Self.fetchObject(from: url, using: context) {
            return Binding(get: {
                table
            }, set: {
                table.storedItemName = $0.itemName
                print("Old table: ", table.objectID.uriRepresentation())
                print("New Table: ", $0.objectID.uriRepresentation())
                
                do {
                    try context.save()
                } catch {
                    print("Error saving to core Data: ", error.localizedDescription)
                }
            })
        } else {
            return nil
        }
    }
}
