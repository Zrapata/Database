//
//  ContentView.swift
//  Shared
//
//  Created by Alejandro Bacelis on 22/11/21.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedWorkspace: WorkSpace?
    @State private var showSettings = false
    
    @Environment(\.managedObjectContext) var viewContext
    
    @SceneStorage("selected_table") var tableID: TableIDType = defatultTableID
    @SceneStorage("selected_projejct") var projectID: ProjectIDType = defatultProjectID
    
    @State private var selectedSettings: SettingsCathegories? = nil
    
    @AppStorage("selected_workspace") var workspaceID: URL = emptyCoreDataURL
    

    var body: some View {
        NavigationView {
            TableSelectorView()
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        Button(action: {
                            self.showSettings.toggle()
                        }) {
                            Label("Settings", systemImage: "gear")
                        }
                    }
                }
            TableDetailView(currentTableID: tableID, context: viewContext)
        }
        .onContinueUserActivity(settingsSelectionUserActivityType, perform: { activity in
            if let settingPanel = activity.userInfo?["settings_panel"] as? String,
            let panel = SettingsCathegories(rawValue: settingPanel) {
                selectedSettings = panel
                self.showSettings = true
            }
            print(activity.userInfo)
//            selectedSettings = activity.userInfo?["settings_panel"] as? SettingsCathegories
//            self.showSettings = true
        })
        .sheet(isPresented: $showSettings) {
            SettingsView(selectedCathegory: $selectedSettings)
        }
        .onAppear {
            if workspaceID == emptyCoreDataURL {
                makeWorkspaceSelection()
            }
        }
        .onChange(of: tableID) { newValue in
            defatultTableID = newValue
        }
        .onChange(of: projectID) { newValue in
            defatultProjectID = newValue
        }
        .onChange(of: workspaceID) { newValue in
            if newValue == emptyCoreDataURL {
                makeWorkspaceSelection()
            } else if selectedSettings == .workspaces {
                selectedSettings = nil
            }
        }
    }
    
    private func makeWorkspaceSelection() {
        self.showSettings = true
        self.selectedSettings = .workspaces
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
