//
//  ToDoJsonTests.swift
//  ToDoJsonTests
//
//  Created by ios_developer on 15.06.2023.
//

import XCTest
@testable import ToDo

final class ToDoJsonTests: XCTestCase {

    func testGeneralJsonReversibility() throws {
        let todo = TodoItem(
            id: "",
            text: "",
            importance: .important,
            deadline: Date(timeIntervalSince1970: 1),
            isComplete: true,
            creationDate: Date(timeIntervalSince1970: 2),
            modificationDate: Date(timeIntervalSince1970: 3)
        )
        guard let parsedTodo = TodoItem.parse(json: todo.json) else {
            XCTFail("Parsing failed")
            return
        }
        XCTAssertEqual(todo, parsedTodo)
    }
    
    func testMinimumJsonReversibility() throws {
        let todo = TodoItem(text: "🤡", importance: .normal, isComplete: false)
        guard let parsedTodo = TodoItem.parse(json: todo.json) else {
            XCTFail("Parsing failed")
            return
        }
        XCTAssertEqual(todo, parsedTodo)
    }
    
    func testGeneralJsonTranslation() throws {
        let id = "123"
        let text = "i can write things"
        let importance = "unimportant"
        let deadline = 1686906471.452346
        let isComplete = false
        let creationDate = 1686906222
        let modificationDate = 1686906471.123
        
        let todoJson = TodoItem(
            id: id,
            text: text,
            importance: try XCTUnwrap(Importance(rawValue: importance)),
            deadline: Date(timeIntervalSince1970: TimeInterval(deadline)),
            isComplete: isComplete,
            creationDate: Date(timeIntervalSince1970: TimeInterval(creationDate)),
            modificationDate: Date(timeIntervalSince1970: TimeInterval(modificationDate))
        ).json
        
        guard let todoJson = todoJson as? [String: Any] else {
            XCTFail("Serialization failed")
            return
        }
        XCTAssertEqual(todoJson.count, 7)
        XCTAssertEqual(todoJson["id"] as? String, id)
        XCTAssertEqual(todoJson["text"] as? String, text)
        XCTAssertEqual(todoJson["importance"] as? String, importance)
        XCTAssertEqual(todoJson["deadline"] as? Double, deadline)
        XCTAssertEqual(todoJson["isComplete"] as? Bool, isComplete)
        XCTAssertEqual(todoJson["creationDate"] as? Double, Double(creationDate))
        XCTAssertEqual(todoJson["modificationDate"] as? Double, modificationDate)
    }
    
    func testMinimumJsonTranslation() throws {
        let todoJson = TodoItem(text: "", importance: .normal, isComplete: true).json
        
        guard let todoJson = todoJson as? [String: Any] else {
            XCTFail("Serialization failed")
            return
        }
        XCTAssertEqual(todoJson.count, 4)
        XCTAssertNotNil(todoJson["id"] as? String)
        XCTAssertEqual(todoJson["text"] as? String, "")
        XCTAssertNil(todoJson["importance"])
        XCTAssertNil(todoJson["deadline"])
        XCTAssertEqual(todoJson["isComplete"] as? Bool, true)
        XCTAssertNotNil(todoJson["creationDate"] as? Double)
        XCTAssertNil(todoJson["modificationDate"])
    }
    
    func testGeneralJsonParse() throws {
        let id = "123"
        let text = "i can write things"
        let importance = "unimportant"
        let deadline = 1686906471.452346
        let isComplete = false
        let creationDate = 1686906222.0
        let modificationDate = 1686906471.123
        
        let json: [String: Any] = [
            "id": id,
            "text": text,
            "importance": importance,
            "deadline": deadline,
            "isComplete": isComplete,
            "creationDate": creationDate,
            "modificationDate": modificationDate
        ]
        
        guard let todo = TodoItem.parse(json: json) else {
            XCTFail("Parsing failed")
            return
        }
        
        XCTAssertEqual(todo.id, id)
        XCTAssertEqual(todo.text, text)
        XCTAssertEqual(todo.importance, .unimportant)
        XCTAssertEqual(todo.deadline, Date(timeIntervalSince1970: deadline))
        XCTAssertEqual(todo.isComplete, isComplete)
        XCTAssertEqual(todo.creationDate, Date(timeIntervalSince1970: TimeInterval(creationDate)))
        XCTAssertEqual(todo.modificationDate, Date(timeIntervalSince1970: modificationDate))
    }
    
    func testMinimumJsonParse() throws {
        let id = "123"
        let text = "i can write things"
        let isComplete = true
        let creationDate = Date().timeIntervalSince1970
        
        let json: [String: Any] = [
            "id": id,
            "text": text,
            "isComplete": isComplete,
            "creationDate": creationDate,
        ]
        
        guard let todo = TodoItem.parse(json: json) else {
            XCTFail("Parsing failed")
            return
        }
        
        XCTAssertEqual(todo.id, id)
        XCTAssertEqual(todo.text, text)
        XCTAssertEqual(todo.importance, .normal)
        XCTAssertEqual(todo.deadline, nil)
        XCTAssertEqual(todo.isComplete, isComplete)
        XCTAssertEqual(todo.creationDate, Date(timeIntervalSince1970: creationDate))
        XCTAssertEqual(todo.modificationDate, nil)
    }
    
    func testExtraKeyJsonParse() throws {
        let id = "123"
        let text = "i can write things"
        let isComplete = true
        let creationDate = Date().timeIntervalSince1970
        
        let json: [String: Any] = [
            "id": id,
            "text": text,
            "isComplete": isComplete,
            "creationDate": creationDate,
            "SOMEBODY_ONES_TOLD_ME": "the world is gonna roll me"
        ]
        
        guard let todo = TodoItem.parse(json: json) else {
            XCTFail("JSON parsing fail")
            return
        }
        
        XCTAssertEqual(todo.id, id)
        XCTAssertEqual(todo.text, text)
        XCTAssertEqual(todo.importance, .normal)
        XCTAssertEqual(todo.deadline, nil)
        XCTAssertEqual(todo.isComplete, isComplete)
        XCTAssertEqual(todo.creationDate, Date(timeIntervalSince1970: creationDate))
        XCTAssertEqual(todo.modificationDate, nil)
    }
    
    func testInvalidOptionalKeyJsonParse() throws {
        let invalidModificationDateJson: [String: Any] = [
            "id": "123",
            "text": "text",
            "isComplete": true,
            "creationDate": 123.0,
            "modificationDate": "modificationDate"
        ]
        let todo1 = TodoItem.parse(json: invalidModificationDateJson)
        XCTAssertNotNil(todo1)
        XCTAssertEqual(todo1!.modificationDate, nil)
        
        let invalidDeadlineJson: [String: Any] = [
            "id": "123",
            "text": "text",
            "isComplete": true,
            "creationDate": 123.0,
            "deadline": false,
        ]
        let todo2 = TodoItem.parse(json: invalidDeadlineJson)
        XCTAssertNotNil(todo2)
        XCTAssertEqual(todo2!.deadline, nil)
        
        let invalidImportanceJson: [String: Any] = [
            "id": "123",
            "text": "text",
            "isComplete": true,
            "creationDate": 123.0,
            "importance": 1,
        ]
        let todo3 = TodoItem.parse(json: invalidImportanceJson)
        XCTAssertNotNil(todo3)
        XCTAssertEqual(todo3!.importance, .normal)
    }
    
    
    func testJsonParseNotEnoughFieldsFail() throws {
        let noIdJson: [String: Any] = [
            "text": "text",
            "isComplete": true,
            "creationDate": 123.0,
        ]
        XCTAssertNil(TodoItem.parse(json: noIdJson))
        
        let noTextJson: [String: Any] = [
            "id": "123",
            "isComplete": true,
            "creationDate": 123.0,
        ]
        XCTAssertNil(TodoItem.parse(json: noTextJson))
        
        let noIsCompleteJson: [String: Any] = [
            "id": "123",
            "text": "text",
            "creationDate": 123.0,
        ]
        XCTAssertNil(TodoItem.parse(json: noIsCompleteJson))
        
        let noCreationDateJson: [String: Any] = [
            "id": "123",
            "text": "text",
            "isComplete": true,
        ]
        XCTAssertNil(TodoItem.parse(json: noCreationDateJson))
    }
    
    func testJsonParseInvalidTypeFail() throws {
        let invalidIdJson: [String: Any] = [
            "id": 123,
            "text": "text",
            "isComplete": true,
            "creationDate": 123.0,
        ]
        XCTAssertNil(TodoItem.parse(json: invalidIdJson))
        
        let invalidTextJson: [String: Any] = [
            "id": "123",
            "text": 123456789,
            "isComplete": true,
            "creationDate": 123.0,
        ]
        XCTAssertNil(TodoItem.parse(json: invalidTextJson))
        
        let invalidIsCompleteJson: [String: Any] = [
            "id": "123",
            "text": "text",
            "isComplete": 123,
            "creationDate": 123.0,
        ]
        XCTAssertNil(TodoItem.parse(json: invalidIsCompleteJson))
        
        let invalidCreationDateJson: [String: Any] = [
            "id": "123",
            "text": "text",
            "isComplete": true,
            "creationDate": true,
        ]
        XCTAssertNil(TodoItem.parse(json: invalidCreationDateJson))
    }
}
