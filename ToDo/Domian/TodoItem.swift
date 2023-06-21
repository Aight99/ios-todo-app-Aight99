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

struct TodoItem {
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isComplete: Bool
    let creationDate: Date
    let modificationDate: Date?
    
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
        
        var importance: Importance = .normal
        if let stringImportance = keyToValue[Key.importance] as? String,
           let enumImportance = Importance(rawValue: stringImportance) {
            importance = enumImportance
        }
        var deadline: Date? = nil
        if let deadlineTimeInterval = keyToValue[Key.deadline] as? TimeInterval {
            deadline = Date(timeIntervalSince1970: deadlineTimeInterval)
        }
        var modification: Date? = nil
        if let modificationTimeInterval = keyToValue[Key.modificationDate] as? TimeInterval {
            modification = Date(timeIntervalSince1970: modificationTimeInterval)
        }
    
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

extension TodoItem {
    
    var csv: String {
        var importanceString = ""
        if self.importance != Importance.normal {
            importanceString = self.importance.rawValue
        }
        var deadlineString = ""
        if let deadline = self.deadline?.timeIntervalSince1970 {
            deadlineString = String(deadline)
        }
        var modificationString = ""
        if let modification = self.modificationDate?.timeIntervalSince1970 {
            modificationString = String(modification)
        }
        let creationString = String(self.creationDate.timeIntervalSince1970)
        
        let dataArray: [String] = [
            self.id,
            self.text,
            importanceString,
            deadlineString,
            String(self.isComplete),
            creationString,
            modificationString
        ]
        
        return dataArray.joined(separator: ";")
    }
    
    static func parse(csv: String) -> TodoItem? {
        let csvArray = csv.components(separatedBy: ";")
        guard let creationTimeInterval = TimeInterval(csvArray[5]),
              csvArray.count == 7,
              csvArray[4] == "true" || csvArray[4] == "false" else {
            return nil
        }
        
        let id = csvArray[0]
        let text = csvArray[1]
        let importance = Importance(rawValue: csvArray[2]) ?? .normal
        let isComplete = csvArray[4] == "true"
        let creation = Date(timeIntervalSince1970: creationTimeInterval)
                
        var deadline: Date? = nil
        if let deadlineTimeInterval = TimeInterval(csvArray[3]) {
            deadline = Date(timeIntervalSince1970: deadlineTimeInterval)
        }
        var modification: Date? = nil
        if let modificationTimeInterval = TimeInterval(csvArray[6]) {
            modification = Date(timeIntervalSince1970: modificationTimeInterval)
        }
        
        return TodoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isComplete: isComplete,
            creationDate: creation,
            modificationDate: modification
        )
    }
    
    
}
