//
//  WorkspacePicker.swift
//  Database
//
//  Created by Alejandro Bacelis on 25/11/21.
//

import SwiftUI

struct WorkspaceSelectorView: View {
//    @Binding var selectedWorkspaceID: URL
    
    @Environment(\.managedObjectContext) var viewContext
    
    @AppStorage("selected_workspace") var selectedWorkspaceID: URL = emptyCoreDataURL
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WorkSpace.storedItemName, ascending: true)],
        animation: .default)
    private var workspaces: FetchedResults<WorkSpace>
    
    var body: some View {
        Form {
            ForEach(workspaces) { workspace in
                Button(action: {
                    selectedWorkspaceID = workspace.objectID.uriRepresentation()
                }) {
                    HStack {
                        workspace.itemNameText
                        Spacer()
                        if workspace.objectID.uriRepresentation() == selectedWorkspaceID {
                            Image(systemName: "circle")
                        }
                    }
                }
            }
            if workspaces.count == 0 {
                AddWorkspaceButton()
            }
        }
        .navigationTitle("Edit Workspaces")
        .toolbar {
            ToolbarItem {
                AddWorkspaceButton()
            }
        }
    }
}

struct WorkspacePicker: View {
    
    @State var isActive: Bool = false
    var style: ViewStyle = .form
    
    @Environment(\.managedObjectContext) var viewContext
    @AppStorage("selected_workspace") var worksapceID: URL = emptyCoreDataURL
    
    var body: some View {
        NavigationLink(
            isActive: $isActive,
            destination: { WorkspaceSelectorView() },
            label: {
                style.makeLabel(for: WorkSpace.fetchObject(from: worksapceID, using: viewContext))
            })
    }
}

extension WorkspacePicker {
    enum ViewStyle {
        case label, form
        
        @ViewBuilder
        func makeLabel(for selection: WorkSpace?) -> some View {
            switch self {
            case .label:
                MainView.workspace.label
            case .form:
                HStack {
                    Text("Workspace")
                    Spacer()
                    Text(selection?.itemName ?? "")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct WorkspacePicker_Previews: PreviewProvider {
    static var previews: some View {
        WorkspacePicker()
    }
}
