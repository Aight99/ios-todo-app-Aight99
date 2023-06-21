//
//  FileCacheTests.swift
//  ToDoTests
//
//  Created by ios_developer on 17.06.2023.
//

import XCTest
@testable import ToDo

final class FileCacheTests: XCTestCase {
    
    // Т.к. тестировать это необязательно, особо не заморачивался
    
    var fileCache: FileCache!

    override func setUpWithError() throws {
        fileCache = FileCache()
        for _ in 0...5 {
            fileCache.add(todo: TodoItem(text: "", importance: .unimportant, isComplete: false))
        }
    }

    override func tearDownWithError() throws {
        fileCache = nil
    }

    func testJsonReadWrite() throws {
        XCTAssertNoThrow(try fileCache.saveJsonOnDevice(filename: "aaa"))
        XCTAssertNoThrow(try fileCache.loadTodoItemsFromJson(filename: "aaa"))
    }
    
    func testJsonManyFiles() throws {
        let firstItems = fileCache.todoItems
        XCTAssertNoThrow(try fileCache.saveJsonOnDevice(filename: "aaa"))
        fileCache.add(todo: TodoItem(text: "Y&&Y", importance: .important, isComplete: true))
        let secondItems = fileCache.todoItems
        XCTAssertTrue(firstItems.count < secondItems.count)
        XCTAssertNoThrow(try fileCache.saveJsonOnDevice(filename: "you"))
        
        XCTAssertNoThrow(try fileCache.loadTodoItemsFromJson(filename: "aaa"))
        XCTAssertTrue(firstItems.count == fileCache.todoItems.count)
        XCTAssertNoThrow(try fileCache.loadTodoItemsFromJson(filename: "you"))
        XCTAssertTrue(secondItems.count == fileCache.todoItems.count)
    }
    
    func testJsonRewrite() throws {
        let firstItems = fileCache.todoItems
        XCTAssertNoThrow(try fileCache.saveJsonOnDevice(filename: "aaa"))
        fileCache.remove(todoId: firstItems[0].id)
        XCTAssertTrue(firstItems.count > fileCache.todoItems.count)
        XCTAssertNoThrow(try fileCache.saveJsonOnDevice(filename: "aaa"))
        XCTAssertNoThrow(try fileCache.loadTodoItemsFromJson(filename: "aaa"))
        XCTAssertTrue(firstItems.count > fileCache.todoItems.count)
    }
    
    func testJsonNotExist() throws {
        XCTAssertThrowsError(try fileCache.loadTodoItemsFromJson(filename: "neverGonnaGiveYouUp"))
    }
    
    func testCsvReadWrite() throws {
        XCTAssertNoThrow(try fileCache.saveCsvOnDevice(filename: "cat"))
        XCTAssertNoThrow(try fileCache.loadTodoItemsFromCsv(filename: "cat"))
    }
    
    func testCsvManyFiles() throws {
        let firstItems = fileCache.todoItems
        XCTAssertNoThrow(try fileCache.saveCsvOnDevice(filename: "cat"))
        fileCache.add(todo: TodoItem(text: "Y&&Y", importance: .important, isComplete: true))
        let secondItems = fileCache.todoItems
        XCTAssertTrue(firstItems.count < secondItems.count)
        XCTAssertNoThrow(try fileCache.saveCsvOnDevice(filename: "kitty"))
        
        XCTAssertNoThrow(try fileCache.loadTodoItemsFromCsv(filename: "cat"))
        XCTAssertTrue(firstItems.count == fileCache.todoItems.count)
        XCTAssertNoThrow(try fileCache.loadTodoItemsFromCsv(filename: "kitty"))
        XCTAssertTrue(secondItems.count == fileCache.todoItems.count)
    }
    
    func testCsvRewrite() throws {
        let firstItems = fileCache.todoItems
        XCTAssertNoThrow(try fileCache.saveCsvOnDevice(filename: "cat"))
        fileCache.remove(todoId: firstItems[0].id)
        XCTAssertTrue(firstItems.count > fileCache.todoItems.count)
        XCTAssertNoThrow(try fileCache.saveCsvOnDevice(filename: "cat"))
        XCTAssertNoThrow(try fileCache.loadTodoItemsFromCsv(filename: "cat"))
        XCTAssertTrue(firstItems.count > fileCache.todoItems.count)
    }
    
    func testCsvNotExist() throws {
        XCTAssertThrowsError(try fileCache.loadTodoItemsFromCsv(filename: "neverGonnaLetYouDown"))
    }
}
