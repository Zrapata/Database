//
//  AddWorkspaceButton.swift
//  Database
//
//  Created by Alejandro Bacelis on 25/11/21.
//

import SwiftUI

struct AddWorkspaceButton: View {
    let type: MainView = .workspace
    
    @AppStorage("selected_workspace") var workspaceID: URL = emptyCoreDataURL
    @Environment(\.managedObjectContext) var viewContext
    
    var body: some View {
        Button(action: addItem) {
            type.addButtonLabel
        }
    }
    
    private func addItem() {
        withAnimation {
            let newWorkspace = WorkSpace(context: viewContext)
            newWorkspace.storedItemName = "Sample WorkSpace"
            newWorkspace.storedItemIconName = "checkmark"
            
            do {
                try viewContext.save()
                workspaceID = newWorkspace.objectID.uriRepresentation()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct AddWorkspaceButton_Previews: PreviewProvider {
    static var previews: some View {
        AddWorkspaceButton()
    }
}
