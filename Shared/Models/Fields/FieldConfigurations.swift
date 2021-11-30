//
//  FieldConfigurations.swift
//  Database
//
//  Created by Alejandro Bacelis on 28/11/21.
//

import SwiftUI

struct FieldConfiguration {
    var type: FieldType
    var data: Data
    
    @ViewBuilder
    func makeCell(_ item: DatabaseItem) -> some View {
        switch item.wrappedField.type.clas {
        case .text:
            TextField("Value", text: item.bindingString() ?? .constant(""))
//        case .others:
//
//        case .date:
//
//        case .file:
//
//        case .number:
            
        default:
            Text(item.objectID.uriRepresentation().absoluteString)
        }
    }
}
