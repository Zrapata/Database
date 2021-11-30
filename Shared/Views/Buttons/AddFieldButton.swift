//
//  AddFieldButton.swift
//  Database
//
//  Created by Alejandro Bacelis on 28/11/21.
//

import SwiftUI

struct AddFieldButton: View {
    @Environment(\.managedObjectContext) var viewContext
    let tableID: TableIDType
    
    var body: some View {
        Button(action: {
            do {
                try Tables.addField(using: tableID, at: viewContext)
            } catch {
                fatalError(error.localizedDescription)
            }
            
        }) {
            Label("Add Field", systemImage: "plus")
        }
    }
}

struct AddFieldButton_Previews: PreviewProvider {
    static var previews: some View {
        AddFieldButton(tableID: emptyCoreDataURL)
    }
}
