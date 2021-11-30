//
//  Project.swift
//  Database
//
//  Created by Alejandro Bacelis on 22/11/21.
//

import SwiftUI

extension LabelItem {
    var itemName: String {
        get { self.storedItemName ?? "No name" }
        set { self.storedItemName = newValue }
    }
    var itemNameText: Text {
        Text(itemName)
    }
    var itemIconName: String {
        get { self.storedItemIconName ?? "questionmark" }
        set { self.storedItemIconName = newValue }
    }
    var itemIcon: Image {
        Image(systemName: itemIconName)
    }
    var itemLabel: Label<Text, Image> {
        Label(title: { itemNameText }, icon: { itemIcon })
    }
}


