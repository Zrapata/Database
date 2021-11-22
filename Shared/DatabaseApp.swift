//
//  DatabaseApp.swift
//  Shared
//
//  Created by Alejandro Bacelis on 22/11/21.
//

import SwiftUI

@main
struct DatabaseApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
