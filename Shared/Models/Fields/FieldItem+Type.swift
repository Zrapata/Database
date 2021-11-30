//
//  File.swift
//  Database
//
//  Created by Alejandro Bacelis on 24/11/21.
//

import Foundation

typealias FieldType = FieldItem.Types

extension FieldItem {
    enum Types: String, CaseIterable {
        // Number
        /// A Number type
        case number
        /// A Number type
        case stepper
        /// A Number type
        case phone
        /// A Number type
        case rating
        /// A Number type
        case auto
        
        // File
        /// A File type
        case anyFile
        /// A File type
        case image
        /// A File type
        case audio
        /// A File type
        case video
        
        // Text
        /// A Text type
        case shortText
        /// A Text type
        case longText
        /// A Text type
        case email
        /// A Text type
        case address
        /// A Text type
        case picker
        
        // Date
        /// A Date type
        case day
        /// A Date type
        case time
        /// A Date type
        case fullDate
        /// A Date type
        case duration
        
        // Others
        /// Some other type
        case relation
        /// Some other type
        case toggle
        /// Some other type
        case barCode
        
        var name: String {
            rawValue.titleCase()
        }
        
        var defaultValue: Data? {
            nil
        }
        
        var clas: Classes {
            switch self {
            case .number, .stepper, .phone, .rating, .auto:
                return .number
            case .anyFile, .image, .audio, .video:
                return .file
            case .shortText, .longText, .email, .address, .picker:
                return .text
            case .day, .time, .fullDate, .duration:
                return .date
            case .relation, .toggle, .barCode:
                return .others
            }
        }
        
        enum Classes: String, CaseIterable {
            case others, date, text, number, file
        }
    }
}
