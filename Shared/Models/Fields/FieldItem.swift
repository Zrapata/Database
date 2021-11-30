//
//  FieldItem.swift
//  Database
//
//  Created by Alejandro Bacelis on 24/11/21.
//

import Foundation
import CoreData

public typealias FieldPositionType = Int16

extension FieldItem {
    func addType(_ type: FieldType) {
        self.type = type
        self.storedType = type.rawValue
    }
    
    var type: FieldType {
        get { FieldType(rawValue: self.storedType ?? FieldType.shortText.rawValue) ?? .shortText }
        set { storedType = newValue.rawValue }
    }
}

struct FieldItemModel: LabelItemModel {
    var itemName: String = "No Name"
    var itemIconName: String = "questionmark"
    var isHidden: Bool = false
    var size: Int? = nil
    var position: Int? = nil
    var type: FieldType = .shortText
    
    func managedObject(_ context: NSManagedObjectContext, with table: Tables) -> FieldItem {
        let newField = FieldItem(context: context)
        
        newField.storedItemName = itemName
        newField.storedItemIconName = itemIconName
        newField.isHidden = isHidden
        newField.storedSize = Int64(size ?? 0)
        newField.storedType = type.rawValue
        
        newField.table = table
        
        return newField
    }
}
