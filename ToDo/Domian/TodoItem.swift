//
//  TodoItem.swift
//  ToDo
//
//  Created by ios_developer on 15.06.2023.
//

import Foundation

enum Importance: String {
    case important
    case normal
    case unimportant
}

struct TodoItem: Equatable {
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isComplete: Bool
    let creationDate: Date
    let modificationDate: Date?

    init() {
        self.init(text: "Что надо сделать?", importance: .normal, isComplete: false)
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

extension TodoItem {
    var oppositeCompletion: TodoItem {
        return TodoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isComplete: !isComplete,
            creationDate: creationDate,
            modificationDate: modificationDate
        )
    }
}

extension TodoItem {

    private enum Key {
        static let id = "id"
        static let text = "text"
        static let importance = "importance"
        static let deadline = "deadline"
        static let isComplete = "isComplete"
        static let creationDate = "creationDate"
        static let modificationDate = "modificationDate"
    }

    var json: Any {
        var jsonDictionary = [String: Any]()

        jsonDictionary[Key.id] = self.id
        jsonDictionary[Key.text] = self.text
        jsonDictionary[Key.isComplete] = self.isComplete
        jsonDictionary[Key.creationDate] = self.creationDate.timeIntervalSince1970

        if self.importance != Importance.normal {
            jsonDictionary[Key.importance] = self.importance.rawValue
        }
        if let deadline = self.deadline?.timeIntervalSince1970 {
            jsonDictionary[Key.deadline] = deadline
        }
        if let modification = self.modificationDate?.timeIntervalSince1970 {
            jsonDictionary[Key.modificationDate] = modification
        }

        return jsonDictionary
    }

    static func parse(json: Any) -> TodoItem? {
        guard let keyToValue = json as? [String: Any],
              let id = keyToValue[Key.id] as? String,
              let text = keyToValue[Key.text] as? String,
              let isComplete = keyToValue[Key.isComplete] as? Bool,
              let creationTimeInterval = keyToValue[Key.creationDate] as? TimeInterval
        else {
            return nil
        }

        let importance: Importance = {
            guard
                let stringImportance = keyToValue[Key.importance] as? String,
                let enumImportance = Importance(rawValue: stringImportance)
            else { return .normal }
            return enumImportance
        }()
        let deadline: Date? = {
            guard
                let deadlineTimeInterval = keyToValue[Key.deadline] as? TimeInterval
            else { return nil}
            return Date(timeIntervalSince1970: deadlineTimeInterval)
        }()
        let modification: Date? = {
            guard
                let modificationTimeInterval = keyToValue[Key.modificationDate] as? TimeInterval
            else { return nil }
            return Date(timeIntervalSince1970: modificationTimeInterval)
        }()

        let creationDate = Date(timeIntervalSince1970: creationTimeInterval)

        return TodoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isComplete: isComplete,
            creationDate: creationDate,
            modificationDate: modification
        )
    }
}
