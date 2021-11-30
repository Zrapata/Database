//
//  DatabaseItem.swift
//  Database
//
//  Created by Alejandro Bacelis on 24/11/21.
//

import Foundation
import SwiftUI
import CoreData

extension DatabaseItem {
    func addField(_ field: FieldItem) {
        self.field = field
        self.storedData = field.defaultValue
    }
    
    var wrappedField: FieldItem {
        if let field = field {
            return field
        }
        else {
            let field = FieldItem()
            field.type = .shortText
            return field
        }
    }
    var stringedData: String? {
        get {
            if let data = storedData {
                return String(data: data, encoding: .utf8)
            } else { return nil }
        } set {
            storedData = newValue?.data(using: .utf8)
            
            do {
                try self.managedObjectContext?.save()
                print("Data saved to core data: ", newValue)
            } catch {
                fatalError("Error while saving to core data: \(error.localizedDescription)")
            }
        }
    }
    
    @ViewBuilder
    func makeBody() -> some View {
        switch wrappedField.type {
        case .shortText:
            TextField("Value", text: bindingString(default: ""))
            
        case .day:
            DatePicker("Date", selection: bindingDate(), displayedComponents: .date)
        case .time:
            DatePicker("Date", selection: bindingDate(), displayedComponents: .hourAndMinute)
        case .fullDate:
            DatePicker("Date", selection: bindingDate())
            
        case .toggle:
            Toggle("Value", isOn: bindingBoolean())
            
        case .number:
            TextField("Value", value: bindingNumber(defaultValue: 0), format: .number)
        default:
            Text(objectID.uriRepresentation().absoluteString)
        }
    }
    func bindingBoolean(defaultValue: Bool = false) -> Binding<Bool> {
        var value: Bool
        
        if storedData == nil {
            value = defaultValue
        } else { value = Bool(stringedData ?? defaultValue.description) ?? defaultValue }
        
        return Binding(get: {
            value
        }, set: {
            self.stringedData = String($0)
        })
    }
    func bindingNumber(defaultValue: Double) -> Binding<Double> {
        var value: Double
        
        if storedData == nil {
            value = defaultValue
        } else {
            value = Double(stringedData ?? String(defaultValue)) ?? defaultValue
        }
        
        return Binding(get: {
            value
        }, set: {
            self.stringedData = String($0)
        })
    }
    
    func bindingDate(default value: Date = Date()) -> Binding<Date> {
        var date: Date
        if storedData == nil {
            date = value
        } else {
            do {
                let stringData = String(data: storedData!, encoding: .utf8) ?? value.ISO8601Format()
                date = try Date(stringData, strategy: .iso8601)
            } catch {
                date = value
            }
        }
        
        return Binding(get: {
            date
        }, set: {
            self.stringedData = $0.ISO8601Format()
        })
    }
    
    func bindingString(default value: String) -> Binding<String> {
        var data: Data
        
        if storedData == nil {
            data = value.data(using: .utf8)!
        } else { data = storedData! }
        
        let returnable: Binding<String> = Binding(get: {
            String(data: data, encoding: .utf8) ?? value
        }, set: {
            self.stringedData = $0
        })
        
        return returnable
    }
    func bindingString() -> Binding<String>? {
        guard let data = storedData, let stringData = String(data: data, encoding: .utf8) else { return nil }
        
        let returnable: Binding<String> = Binding(get: {
            stringData
        }, set: {
            self.stringedData = $0
        })
        
        return returnable
    }
}

struct DatabaseItemModel {
    var data: Data
    
    func managedObject(_ context: NSManagedObjectContext, field: FieldItem, record: RecordItem) -> DatabaseItem {
        let newData = DatabaseItem(context: context)
        
        newData.storedData = data
        
        newData.field = field
        newData.record = record
        
        return newData
    }
    
    func managedObjectAndSave(_ context: NSManagedObjectContext, field: FieldItem, record: RecordItem) throws -> DatabaseItem {
        let newData = managedObject(context, field: field, record: record)
        
        try context.save()
        
        return newData
    }
}
