//
//  WorkspacePicker.swift
//  Database
//
//  Created by Alejandro Bacelis on 25/11/21.
//

import SwiftUI

struct ProjectSelectorView: View {
    
    @AppStorage("selected_workspace") var selectedWorkspaceID: URL = emptyCoreDataURL
    @SceneStorage("selected_project") var selectedProjectID: ProjectIDType = emptyCoreDataURL
    
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Project.storedItemName, ascending: true)],
        animation: .default)
    private var projects: FetchedResults<Project>
    
    var body: some View {
        List {
            Section {
                WorkspacePicker()
            }
            ForEach(projects.filter({ $0.workspace?.objectID.uriRepresentation() == selectedWorkspaceID })) { project in
                Button(action: {
                    selectedProjectID = project.objectID.uriRepresentation()
                }) {
                    HStack {
                        project.itemLabel
                        Spacer()
                        if project.objectID.uriRepresentation() == selectedProjectID {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem {
                AddProjectButton()
            }
        }
    }
}

struct ProjectPicker: View {
    static let selectorType: MainView = .project
    
    var style: ViewStyle = .form
    
    @Environment(\.managedObjectContext) var viewContext
    @SceneStorage("selected_project") var projectID: ProjectIDType = defatultProjectID
    
    var body: some View {
        NavigationLink(destination: {
            ProjectSelectorView()
        }) {
            style.makeLabel(for: Project.fetchObject(from: projectID, using: viewContext))
        }
    }
}

extension ProjectPicker {
    enum ViewStyle {
        case label, form
        
        @ViewBuilder
        func makeLabel(for selection: Project?) -> some View {
            switch self {
            case .label:
                MainView.workspace.label
            case .form:
                HStack {
                    Text(ProjectPicker.selectorType.name)
                    Spacer()
                    (selection?.itemLabel ?? Label("", systemImage: "") as! Label<Text, Image>)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct ProjectPicker_Previews: PreviewProvider {
    static var previews: some View {
        ProjectSelectorView()
    }
}
