//
//  MainViews.swift
//  MainViews
//
//  Created by Alejandro Bacelis on 26/08/21.
//

import SwiftUI

enum MainView: String, CaseIterable, View, Codable, Identifiable {
    case workspace
    case project
    
    var id: String {
        self.rawValue
    }
    
    var body: some View {
        switch self {
        case .workspace:
            WorkspaceSelectorView()
        case .project:
            ProjectSelectorView()
        }
    }
    
    var icon: Image {
        var name: String
        switch self {
        case .workspace:
            name = "tray"
        case .project:
            name = "folder"
        }
        
        return Image(systemName: name)
    }
    
    var name: String {
        self.rawValue.capitalized
    }
    
    var label: Label<Text, Image> {
        Label(title: {
            Text(self.name)
        }, icon: {
            self.icon
        })
    }
    
    var addButtonLabel: Label<Text, Image> {
        Label(title: {
            Text("Add \(self.name)")
        }, icon: {
            Image(systemName: "plus")
        })
    }
}
