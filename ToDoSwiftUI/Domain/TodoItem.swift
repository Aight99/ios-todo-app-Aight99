//
//  TodoItem.swift
//  ToDoSwiftUI
//
//  Created by ios_developer on 22.07.2023.
//

import Foundation

enum Importance: String {
    case important
    case normal
    case unimportant
}

struct TodoItem: Identifiable {
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isComplete: Bool
    let creationDate: Date
    let modificationDate: Date?

    init() {
        self.init(text: "", importance: .normal, isComplete: false)
    }

    init(
        id: String = UUID().uuidString,
        text: String,
        importance: Importance,
        deadline: Date? = nil,
        isComplete: Bool,
        creationDate: Date = Date(),
        modificationDate: Date? = nil
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isComplete = isComplete
        self.creationDate = creationDate
        self.modificationDate = modificationDate
    }
}
