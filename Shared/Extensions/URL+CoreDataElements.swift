//
//  URL+CoreDataElements.swift
//  Database
//
//  Created by Alejandro Bacelis on 26/11/21.
//

import Foundation

public let emptyCoreDataURL = URL(string: "x-coredata://7F80FB8E-C678-4444-A5D8-B49CC082451A/Project/p6")!

public typealias TableIDType = URL
public typealias ProjectIDType = URL
public typealias WorkspaceIDType = URL

public var defatultProjectID: ProjectIDType {
    get {
        UserDefaults.standard.url(forKey: "selected_project") ?? emptyCoreDataURL
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "selected_project")
    }
}
public var defatultTableID: TableIDType {
    get {
        UserDefaults.standard.url(forKey: "selected_table") ?? emptyCoreDataURL
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "selected_table")
    }
}

