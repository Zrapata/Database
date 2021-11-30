//
//  AddRecordButton.swift
//  Database
//
//  Created by Alejandro Bacelis on 28/11/21.
//

import SwiftUI

struct AddRecordButton: View {
    @Environment(\.managedObjectContext) var viewContext
    let tableID: TableIDType
    
    var body: some View {
        Button(action: {
            do {
                let table = Tables.fetchObject(from: tableID, using: viewContext)
                try table?.addRecord()
            } catch {
                fatalError("Failed to save to CoreData with error: \(error)")
            }
        }) {
            Label("Add Record", systemImage: "plus")
        }
    }
}

struct AddRecordButton_Previews: PreviewProvider {
    static var previews: some View {
        AddRecordButton(tableID: emptyCoreDataURL)
    }
}
