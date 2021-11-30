//
//  String+CamelCaseToWords.swift
//  Database
//
//  Created by Alejandro Bacelis on 28/11/21.
//

import Foundation

extension String {
    func titleCase() -> String {
        return self
            .replacingOccurrences(of: "([A-Z])",
                                  with: " $1",
                                  options: .regularExpression,
                                  range: range(of: self))
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .capitalized // If input is in llamaCase
    }
}
