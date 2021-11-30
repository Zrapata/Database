//
//  SettingsView.swift
//  Database
//
//  Created by Alejandro Bacelis on 25/11/21.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("selected_workspace") var workspaceID: URL = emptyCoreDataURL
  
    @Binding var selectedCathegory: SettingsCathegories?
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    SubscribePanel(isActive: selectedCathegory == .subscribe)
                }
                WorkspacePicker(isActive: selectedCathegory == .workspaces)
            }
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(selectedCathegory: .constant(nil))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
