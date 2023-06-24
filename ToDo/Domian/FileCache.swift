//
//  FileCache.swift
//  ToDo
//
//  Created by ios_developer on 15.06.2023.
//

import Foundation

enum FileCacheError: Error {
    case invalidPath
    case failedSerialization
    case failedDeserialization
}

final class FileCache {
    private(set) var todoItems = [String: TodoItem]()

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

