//
//  Tables+FetchArray.swift
//  Database
//
//  Created by Alejandro Bacelis on 29/11/21.
//

import Foundation

extension Tables {
    func filteredFields(for type: FieldType) -> [FieldItem] {
        wrappedFields.filter({ $0.type == type })
    }
}
