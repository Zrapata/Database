//
//  TableDetailView.swift
//  Database
//
//  Created by Alejandro Bacelis on 25/11/21.
//

import SwiftUI
import CoreData
import TableView

struct TableDetailView: View {
    @Environment(\.managedObjectContext) var viewContext
    
    @State var tableIsNotNil: Bool
    @Binding var table: Tables
    
    @State private var showTableEditor = false
    
    var body: some View {
        if tableIsNotNil {
            List {
                ForEach(table.wrappedRecords) { records in
//                    Text("Hello")
                    Section(content: {
                        ForEach(records.wrappedData.sorted { (lhs, rhs) in {
                            lhs.wrappedField.storedPosition < rhs.wrappedField.storedPosition
                        }()}) { record in
                            HStack {
                                Text(record.wrappedField.itemName)
                                record.makeBody()
                            }
                        }
                    }, header: {
                        Text("Record Title")
                    })
                }
            }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        TextField("Table Name", text: $table.itemName)
                            .frame(maxWidth: 150)
                            .padding(.vertical, 3)
                            .padding(.horizontal, 5)
                            .background(Color.fill)
                            .cornerRadius(5)
                            .multilineTextAlignment(.center)
                    }
                    ToolbarItemGroup {
                        Button("Prirnt") {
                            print(table.wrappedFields.map { $0.storedPosition })
                        }
                        Button(action: {
                            self.showTableEditor.toggle()
                        }) {
                            Label("Edit Table", systemImage: "slider.horizontal.3")
                        }
                        .sheet(isPresented: $showTableEditor) {
                            NavigationView {
                                EditTableFieldsView(table: $table)
                            }
                        }
                        AddRecordButton(tableID: table.objectID.uriRepresentation())
                            .disabled(table.wrappedFields.isEmpty)
                    }
                }
//            Form {
//                TextField("Name", text: $table.itemName)
//                TVTableView()
//            }
        } else {
            EmptyView()
        }
    }
    
    init(currentTableID: TableIDType, context: NSManagedObjectContext) {
        
        if let bindingTable =  Tables.bindingObject(from: currentTableID, using: context) {
            _table = bindingTable
            tableIsNotNil = true
        } else {
            _table = .constant(Tables())
            tableIsNotNil = false
        }
    }
}

struct TableDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TableDetailView(currentTableID: emptyCoreDataURL, context: PersistenceController.preview.container.viewContext)
    }
}
