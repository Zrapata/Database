//
//  SubscribePanel.swift
//  Database
//
//  Created by Alejandro Bacelis on 29/11/21.
//

import SwiftUI

struct SubscribePanel: View {
    @State var isActive = false
    
    var body: some View {
        NavigationLink(
            isActive: $isActive,
            destination: {
                SubscribePanelDetailsView()
            },
            label: {
                Label("Subscribe", systemImage: "star.fill")
            })
    }
}

struct SubscribePanelDetailsView: View {
    var body: some View {
        Link("Subscribe", destination: URL(string: "https://twitch.tv/Zrapata")!)
    }
}

struct SubscribePanel_Previews: PreviewProvider {
    static var previews: some View {
        SubscribePanel()
    }
}
