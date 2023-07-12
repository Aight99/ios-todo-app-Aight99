//
//  Extensions.swift
//  ToDo
//
//  Created by ios_developer on 13.07.2023.
//

import Foundation

extension Bool {
    var intValue: Int {
        return self ? 1 : 0
    }
}

extension Double {
    var stringValue: String {
        return String(self)
    }
}

extension String {
    var quoted: String {
        return "'\(self)'"
    }
}
