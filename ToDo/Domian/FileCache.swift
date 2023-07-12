//
//  FileCache.swift
//  ToDo
//
//  Created by ios_developer on 15.06.2023.
//

import Foundation
import SQLite

enum FileCacheError: Error {
    case invalidPath
    case sqlConnectionFail
    case failedSerialization
    case failedDeserialization
}

final class FileCache {

    let dbFileName: String
    private(set) var todoItems = [String: TodoItem]()

    init(dbFileName: String = "todoItems") {
        self.dbFileName = dbFileName
        do {
            try createSqlTable()
        } catch {
            print(error)
        }
    }

    var sortedItems: [TodoItem] {
        return todoItems.sorted{ $0.value.creationDate > $1.value.creationDate }.map{ $0.value }
    }

    @discardableResult
    func add(todo: TodoItem) -> TodoItem? {
        let replacedTodo = todoItems[todo.id]
        todoItems[todo.id] = todo
        return replacedTodo
    }

    @discardableResult
    func remove(todoId: String) -> TodoItem? {
        let removedTodo = todoItems[todoId]
        todoItems[todoId] = nil
        return removedTodo
    }
}

extension FileCache {

    func saveInSql() throws {
        let db = try getDbConnection()
        for item in todoItems.values {
            let query = item.sqlReplaceStatement
            try db.run(query)
        }
    }

    func insertInSql(todo: TodoItem) throws {
        let db = try getDbConnection()
        let query = todo.sqlInsertStatement
        try db.run(query)
    }

    func updateInSql(todo: TodoItem) throws {
        let db = try getDbConnection()
        let query = todo.sqlDeleteStatement
        try db.run(query)
    }

    func deleteInSql(todoId: String) throws {
        let db = try getDbConnection()
        guard let todo = todoItems[todoId] else {
            return
        }
        let query = todo.sqlDeleteStatement
        try db.run(query)
    }

    func loadFromSql() throws {
        var items = [String: TodoItem]()
        let db = try getDbConnection()
        let table = Table(SqlTableKeys.tableName)
        let query = table.select(*)

        let id = Expression<String>(SqlTableKeys.id)
        let text = Expression<String>(SqlTableKeys.text)
        let importance = Expression<String>(SqlTableKeys.importance)
        let deadline = Expression<Double?>(SqlTableKeys.deadline)
        let isComplete = Expression<Bool>(SqlTableKeys.isComplete)
        let creationDate = Expression<Double>(SqlTableKeys.creationDate)
        let modificationDate = Expression<Double?>(SqlTableKeys.modificationDate)

        for row in try db.prepare(query) {
            let item = TodoItem(
                id: row[id],
                text: row[text],
                importance: Importance(rawValue: row[importance])!,
                deadline: row[deadline].flatMap{ Date(timeIntervalSince1970: $0) },
                isComplete: row[isComplete],
                creationDate: Date(timeIntervalSince1970: row[creationDate]),
                modificationDate: row[modificationDate].flatMap{ Date(timeIntervalSince1970: $0) }
            )
            items[item.id] = item
        }
        todoItems = items
    }

    private func createSqlTable() throws {

        let db = try getDbConnection()

        let table = Table(SqlTableKeys.tableName)
        let id = Expression<String>(SqlTableKeys.id)
        let text = Expression<String>(SqlTableKeys.text)
        let importance = Expression<String>(SqlTableKeys.importance)
        let deadline = Expression<Double?>(SqlTableKeys.deadline)
        let isComplete = Expression<Bool>(SqlTableKeys.isComplete)
        let creationDate = Expression<Double>(SqlTableKeys.creationDate)
        let modificationDate = Expression<Double?>(SqlTableKeys.modificationDate)

        try db.run(table.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(text)
            t.column(importance)
            t.column(deadline)
            t.column(isComplete)
            t.column(creationDate)
            t.column(modificationDate)
        })
    }

    func getDbConnection() throws -> Connection {
        guard
            let dbPath = getDbPath(),
            let connection = try? Connection(dbPath)
        else {
            throw FileCacheError.sqlConnectionFail
        }
        return connection
    }

    func getDbPath() -> String? {
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            return nil
        }
        let fileURL = documentsURL.appendingPathComponent("\(dbFileName).sqlite")
        return fileURL.path
    }
}

enum SqlTableKeys {
    static let tableName = "todoItems"
    static let id = "id"
    static let text = "text"
    static let importance = "importance"
    static let deadline = "deadline"
    static let isComplete = "isComplete"
    static let creationDate = "creationDate"
    static let modificationDate = "modificationDate"
}

extension FileCache {
    func saveJsonOnDevice(filename: String) throws {
        guard let baseUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileCacheError.invalidPath
        }
        let fileUrl = baseUrl.appendingPathComponent("\(filename).json")
        let todoItemsJson = todoItems.map{ $0.value.json }

        guard let jsonData = try? JSONSerialization.data(withJSONObject: todoItemsJson) else {
            throw FileCacheError.failedSerialization
        }

        try jsonData.write(to: fileUrl)
    }

    func loadTodoItemsFromJson(filename: String) throws {
        guard let baseUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileCacheError.invalidPath
        }
        let fileUrl = baseUrl.appendingPathComponent("\(filename).json")
        let jsonData = try Data(contentsOf: fileUrl)

        guard let parsedJsonArray = try? JSONSerialization.jsonObject(with: jsonData) as? [Any],
              let parsedTodoItems = parsedJsonArray.map({ TodoItem.parse(json: $0) }) as? [TodoItem] else {
            throw FileCacheError.failedDeserialization
        }

        todoItems = parsedTodoItems.reduce(into: [:]) { res, todo in
            res[todo.id] = todo
        }
    }
}
