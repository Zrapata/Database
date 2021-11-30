//
//  Tables.swift
//  Database
//
//  Created by Alejandro Bacelis on 23/11/21.
//

import Foundation
import CoreData

extension Tables {
    var mainFieldURL: URL {
        get { self.fieldForName?.objectID.uriRepresentation() ?? emptyCoreDataURL }
        set {
            let field = FieldItem.fetchObject(from: newValue, using: self.managedObjectContext!)
            self.fieldForName = field
        }
    }
    var wrappedRecords: [RecordItem] {
        get { records?.allObjects as? [RecordItem] ?? [] }
        set { records = NSSet(array: newValue) }
    }
    var wrappedFields: [FieldItem] {
        get { fields?.allObjects as? [FieldItem] ?? [] }
        set { fields = NSSet(array: newValue) }
    }
    
    var nextFieldPosition: Int {
        wrappedFields.count + 1
    }
    var nextRecordPosition: Int {
        wrappedRecords.count + 1
    }
    
    static func addField(using tableID: TableIDType, at viewContext: NSManagedObjectContext) throws {
        if let table = Tables.fetchObject(from: tableID, using: viewContext) {
            try table.addField()
        } else {
            throw NSError(domain: "static.table.addField", code: 15, userInfo: nil)
        }
        
    }
    func addField(_ userField: FieldItem? = nil, makeDefault: Bool = true) throws {
        var field: FieldItem
        if userField != nil { field = userField! }
        else { field = FieldItem(context: self.managedObjectContext!) }
        
        if makeDefault {
            field.addType(.shortText)
            field.storedSize = 100
            
            field.storedPosition = FieldPositionType(self.nextFieldPosition)
        }
        
        self.addToFields(field)
        for record in wrappedRecords {
            let newItem = DatabaseItem(context: self.managedObjectContext!)
            newItem.field = field
            newItem.storedData = field.defaultValue

            record.addToFieldData(newItem)
        }
        
        try self.managedObjectContext?.save()
    }
    
    /// Will add a record to the table and set the default parameters like a position and empty values for all the propertis inside
    /// - Parameter record: The record item you want to add to the table, if its nil a default implementation will me added
    /// - Parameter makeDefault: if maked as false no default values will be placed in the record
    /// If makeDefault is set to false, make sure that all the properties are set, and that the fieldItems correspond to the tables fields
    func addRecord(_ userRecord: RecordItem? = nil, makeDefault: Bool = true) throws {
        var record: RecordItem
        if userRecord != nil { record = userRecord! }
        else { record = RecordItem(context: self.managedObjectContext!) }
        
        if makeDefault {
            record.storedID = UUID()
            record.storedPosition = RecordPositionType(self.nextRecordPosition)
            
            for field in wrappedFields {
                let newDataItem = DatabaseItem(context: self.managedObjectContext!)
                newDataItem.addField(field)
                newDataItem.record = record
            }
        }
        self.addToRecords(record)
        
        try self.managedObjectContext?.save()
    }
}

struct TableModel: LabelItemModel {
    var itemName: String
    var itemIconName: String
    
}

protocol LabelItemModel {
    var itemName: String { get set }
    var itemIconName: String { get set }
}
