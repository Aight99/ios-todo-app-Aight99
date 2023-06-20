//
//  ToDoCsvTests.swift
//  ToDoTests
//
//  Created by ios_developer on 17.06.2023.
//

import XCTest
@testable import ToDo

final class ToDoCsvTests: XCTestCase {

    func testGeneralCsvReversibility() throws {
        let todo = TodoItem(
            id: "",
            text: "",
            importance: .important,
            deadline: Date(timeIntervalSince1970: 1),
            isComplete: true,
            creationDate: Date(timeIntervalSince1970: 2),
            modificationDate: Date(timeIntervalSince1970: 3)
        )
        guard let parsedTodo = TodoItem.parse(csv: todo.csv) else {
            XCTFail()
            return
        }
        assertTodosEqual(todo, parsedTodo)
    }
    
    func testMinimumCsvReversibility() throws {
        let todo = TodoItem(text: "🤡", importance: .normal, isComplete: false)
        guard let parsedTodo = TodoItem.parse(csv: todo.csv) else {
            XCTFail()
            return
        }
        assertTodosEqual(todo, parsedTodo)
    }

    func assertTodosEqual(_ todo1: TodoItem, _ todo2: TodoItem) {
        XCTAssertEqual(todo1.id, todo2.id)
        XCTAssertEqual(todo1.text, todo2.text)
        XCTAssertEqual(todo1.importance, todo2.importance)
        XCTAssertEqual(todo1.isComplete, todo2.isComplete)
        XCTAssertEqual(todo1.deadline?.timeIntervalSince1970, todo2.deadline?.timeIntervalSince1970)
        XCTAssertEqual(todo1.creationDate.timeIntervalSince1970, todo2.creationDate.timeIntervalSince1970)
        XCTAssertEqual(todo1.modificationDate?.timeIntervalSince1970, todo2.modificationDate?.timeIntervalSince1970)
    }
    
    func testGeneralCsvTranslation() throws {
        let id = "123"
        let text = "i can write things"
        let importance = "unimportant"
        let deadline = 1686906471.452346
        let isComplete = false
        let creationDate = 1686906222
        let modificationDate = 1686906471.123

        let todoCsv = TodoItem(
            id: id,
            text: text,
            importance: try XCTUnwrap(Importance(rawValue: importance)),
            deadline: Date(timeIntervalSince1970: TimeInterval(deadline)),
            isComplete: isComplete,
            creationDate: Date(timeIntervalSince1970: TimeInterval(creationDate)),
            modificationDate: Date(timeIntervalSince1970: TimeInterval(modificationDate))
        ).csv.components(separatedBy: ";")
        
        XCTAssertEqual(todoCsv.count, 7)
        XCTAssertEqual(todoCsv[0], id)
        XCTAssertEqual(todoCsv[1], text)
        XCTAssertEqual(todoCsv[2], importance)
        XCTAssertEqual(Double(todoCsv[3]), deadline)
        XCTAssertEqual(todoCsv[4], "false")
        XCTAssertEqual(Double(todoCsv[5]), Double(creationDate))
        XCTAssertEqual(Double(todoCsv[6]), modificationDate)
    }

    func testMinimumCsvTranslation() throws {
        let todoCsv = TodoItem(text: "", importance: .normal, isComplete: true).csv.components(separatedBy: ";")
        XCTAssertEqual(todoCsv.count, 7)
        XCTAssertNotNil(todoCsv[0])
        XCTAssertEqual(todoCsv[1], "")
        XCTAssertEqual(todoCsv[2], "")
        XCTAssertEqual(todoCsv[3], "")
        XCTAssertEqual(todoCsv[4], "true")
        XCTAssertNotNil(Double(todoCsv[5]))
        XCTAssertEqual(todoCsv[6], "")
    }

    func testGeneralCsvParse() throws {
        let id = "123"
        let text = "i can write things"
        let importance = "unimportant"
        let deadline = 1686906471.452346
        let isComplete = false
        let creationDate = 1686906222.0
        let modificationDate = 1686906471.123

        let csv = "\(id);\(text);\(importance);\(deadline);\(isComplete);\(creationDate);\(modificationDate)"

        guard let todo = TodoItem.parse(csv: csv) else {
            XCTFail("Csv parsing fail")
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

    func testMinimumCsvParse() throws {
        let id = "123"
        let text = "i can write things"
        let isComplete = true
        let creationDate = Date().timeIntervalSince1970

        let csv = "\(id);\(text);;;\(isComplete);\(creationDate);"

        guard let todo = TodoItem.parse(csv: csv) else {
            XCTFail("Csv parsing fail")
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

    func testInvalidOptionalKeyCsvParse() throws {
        let invalidModificationDateCsv = "id;text;;;true;123.0;YESTERDAY"
        let todo1 = TodoItem.parse(csv: invalidModificationDateCsv)
        XCTAssertNotNil(todo1)
        XCTAssertEqual(todo1!.modificationDate, nil)
        
        let invalidDeadlineCsv = "id;text;;VERY YESTERDAY;true;123.0;"
        let todo2 = TodoItem.parse(csv: invalidDeadlineCsv)
        XCTAssertNotNil(todo2)
        XCTAssertEqual(todo2!.deadline, nil)
        
        let invalidImportanceCsv = "id;text;VAJNO;;true;123.0;"
        let todo3 = TodoItem.parse(csv: invalidImportanceCsv)
        XCTAssertNotNil(todo3)
        XCTAssertEqual(todo3!.importance, .normal)
    }
    
    func testExtraKeyCsvParseFail() throws {
        let id = "123"
        let text = "i can write things"
        let isComplete = true
        let creationDate = Date().timeIntervalSince1970

        let csv = "\(id);\(text);;;\(isComplete);\(creationDate);;"
        XCTAssertNil(TodoItem.parse(csv: csv))
    }
    
    func testNotEnoughKeyCsvParseFail() throws {
        let id = "123"
        let text = "i can write things"
        let isComplete = true
        let creationDate = Date().timeIntervalSince1970

        let csv = "\(id);\(text);;;\(isComplete);\(creationDate)"
        XCTAssertNil(TodoItem.parse(csv: csv))
    }

    func testCsvParseInvalidTypeFail() throws {
        let invalidIsCompleteCsv = "id;text;;;YES;123.0;"
        XCTAssertNil(TodoItem.parse(csv: invalidIsCompleteCsv))

        let invalidCreationDateCsv = "id;text;;;true;TODAY;"
        XCTAssertNil(TodoItem.parse(csv: invalidCreationDateCsv))
    }
}
