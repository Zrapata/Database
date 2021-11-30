//
//  Persistence.swift
//  Shared
//
//  Created by Alejandro Bacelis on 22/11/21.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let workspaceOne = WorkSpace(context: viewContext)
        workspaceOne.storedItemIconName = "cirlce.fill"
        workspaceOne.storedItemName = "Sample Workspace"
        
        let workspaceTwo = WorkSpace(context: viewContext)
        workspaceTwo.storedItemIconName = "square.fill"
        workspaceTwo.storedItemName = "Sample Workspace Two"
        
        for i in 0..<4 {
            let newProject = Project(context: viewContext)
            newProject.storedItemIconName = "\(i).circle"
            newProject.storedItemName = "Project #\(i)"
            
            for j in 0..<2 {
                let newTable = Tables(context: viewContext)
                newTable.storedItemName = "\(i) - \(j) Table"
                newTable.storedItemIconName = "\(i).square"
                newTable.project = newProject
            }
            
            if i < 2 {
                newProject.workspace = workspaceOne
            } else {
                newProject.workspace = workspaceTwo
            }
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false, from target: String = "main_app") {
        container = NSPersistentCloudKitContainer(name: "Database")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.viewContext.name = "view_context"
        container.viewContext.transactionAuthor = target
        
        let storeURL = URL.storeURL(for: "group.com.zrapata.personal.Database", with: "SharedDatabase")
        let storeDescriptors = NSPersistentStoreDescription(url: storeURL)
        storeDescriptors.url = storeURL
        storeDescriptors.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        storeDescriptors.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        container.persistentStoreDescriptions = [storeDescriptors]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    enum FetchableEntities {
        case Project
    }
}

extension PersistenceController {
    static var fetchedProjectRequest: NSFetchRequest<Project> {
        Project.fetchRequest()
    }
}
