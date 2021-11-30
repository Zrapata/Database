//
//  Array+ConvertIntent.swift
//  Database
//
//  Created by Alejandro Bacelis on 29/11/21.
//

import Foundation

extension Array where Element == WorkSpace {
    func intentValues() -> [WorkspaceIntent] {
        self.map({ $0.intentValue })
    }
}
extension Array where Element == Project {
    func intentValues() -> [ProjectIntent] {
        self.map({ $0.intentValue })
    }
}
extension Array where Element == Tables {
    func intentValues() -> [TableIntent] {
        self.map({ $0.intentValue })
    }
}
//extension Array where Element == Project {
//    func intentValues() -> [ProjectIntent] {
//        self.map({ $0.intentValue })
//    }
//}
