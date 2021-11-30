//
//  EditTableFieldsView.swift
//  Database
//
//  Created by Alejandro Bacelis on 28/11/21.
//

import SwiftUI

struct EditTableFieldsView: View {
    @Binding var table: Tables
    
    var body: some View {
        List {
            Section("Main Field") {
                Picker("Title Name", selection: $table.mainFieldURL) {
                    ForEach(table.filteredFields(for: .shortText)) { field in
                        Text(field.itemName).tag(field.objectID.uriRepresentation())
                    }
                }
            }
            ForEach($table.wrappedFields) { $field in
                HStack {
                    TextField("Name", text: $field.itemName)
                    Picker("Value", selection: $field.type) {
                        ForEach(FieldType.Classes.allCases, id: \.self) { clas in
                            Divider()
                            ForEach(FieldType.allCases.filter({ $0.clas == clas }), id: \.self) { item in
                                Text(item.name).tag(item)
                            }
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
        }
        .toolbar {
            ToolbarItem {
                AddFieldButton(tableID: table.objectID.uriRepresentation())
            }
        }
        .onChange(of: table) { _ in
            do {
                try table.managedObjectContext?.save()
            } catch {
                print("Error saving to Core Data", error.localizedDescription)
            }
        }
    }
}

struct EditTableFieldsView_Previews: PreviewProvider {
    static var previews: some View {
        EditTableFieldsView(table: .constant(Tables()))
    }
}
