//
//  RecordItem.swift
//  Database
//
//  Created by Alejandro Bacelis on 24/11/21.
//

import Foundation

typealias RecordPositionType = Int32

extension RecordItem {
    var wrappedData: [DatabaseItem] {
        get { fieldData?.allObjects as? [DatabaseItem] ?? [] }
        set { fieldData = NSSet(array: newValue) }
    }
}

struct RecordItemModel {
    var id: UUID
    var position: Int
    var fieldData: DatabaseItemModel
}
