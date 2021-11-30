//
//  AddWorkspaceButton.swift
//  Database
//
//  Created by Alejandro Bacelis on 25/11/21.
//

import SwiftUI

struct AddProjectButton: View {
    let type: MainView = .project
    
    @AppStorage("selected_workspace") var workspaceID: URL = emptyCoreDataURL
    @Environment(\.managedObjectContext) var viewContext
    
    var body: some View {
        Button(action: addItem) {
            type.addButtonLabel
        }
        .disabled(workspaceID == emptyCoreDataURL)
        .keyboardShortcut("n", modifiers: [.command, .control])
    }
    
    private func addItem() {
        withAnimation {
            let newProject = Project(context: viewContext)
            newProject.storedItemName = "Sample Project"
            newProject.storedItemIconName = "circle.fill"
            
            newProject.workspace = WorkSpace.fetchObject(from: workspaceID, using: viewContext)
            
            print(newProject.workspace)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

}

struct AddProjectButton_Previews: PreviewProvider {
    static var previews: some View {
        AddProjectButton()
    }
}
