//
//  DatabaseApp.swift
//  Shared
//
//  Created by Alejandro Bacelis on 22/11/21.
//

import SwiftUI
import Purchases

@main
struct DatabaseApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
    init() {
        setupRevenueCat()
    }
    
    func setupRevenueCat() {
        #if DEBUG
        Purchases.logLevel = .debug
        #endif
        Purchases.configure(withAPIKey: "LmvmvoawFtkeDRKqUrJnAVZWJkJDvcBG")
    }
}
