//
//  FileCache.swift
//  ToDo
//
//  Created by ios_developer on 15.06.2023.
//

import Foundation

enum FileCacheError: Error {
    case invalidPath
    case failedWrite
    case failedRead
    case failedSerialization
    case failedDeserialization
}

final class FileCache {
    private(set) var todoItems = [TodoItem]()
    
    func add(todo: TodoItem) {
        if let existingIndex = todoItems.firstIndex(where: {$0.id == todo.id}) {
            todoItems[existingIndex] = todo
            return
        }
        todoItems.append(todo)
    }
    
    func remove(todoId: String) {
        guard let existingIndex = todoItems.firstIndex(where: {$0.id == todoId}) else { return }
        todoItems.remove(at: existingIndex)
    }
    
    func saveJsonOnDevice(filename: String) throws {
        guard let baseUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileCacheError.invalidPath
        }
        let fileUrl = baseUrl.appendingPathComponent(filename)
        
        let todoItemsJson = todoItems.map{ $0.json }
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: todoItemsJson) else {
            throw FileCacheError.failedSerialization
        }
        
        do {
            try jsonData.write(to: fileUrl)
        } catch {
            throw FileCacheError.failedWrite
        }
    }
    
    func loadTodoItemsFromJson(filename: String) throws {
        guard let baseUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileCacheError.invalidPath
        }
        let fileUrl = baseUrl.appendingPathComponent(filename)
        guard let jsonData = try? Data(contentsOf: fileUrl) else {
            throw FileCacheError.failedRead
        }
        
        guard let parsedJsonArray = try? JSONSerialization.jsonObject(with: jsonData) as? [Any],
              let parsedTodoItems = parsedJsonArray.map({ TodoItem.parse(json: $0) }) as? [TodoItem] else {
            throw FileCacheError.failedDeserialization
        }
        
        todoItems = parsedTodoItems
    }
}

extension FileCache {
    
    func saveCsvOnDevice(filename: String) throws {
        guard let baseUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileCacheError.invalidPath
        }
        let fileUrl = baseUrl.appendingPathComponent(filename)
        
        let todoItemsCsv = todoItems.map{ $0.csv }.joined(separator: "\n")
        let csvData = Data(todoItemsCsv.utf8)
    
        do {
            try csvData.write(to: fileUrl)
        } catch {
            throw FileCacheError.failedWrite
        }
    }
    
    func loadTodoItemsFromCsv(filename: String) throws {
        guard let baseUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileCacheError.invalidPath
        }
        let fileUrl = baseUrl.appendingPathComponent(filename)
        guard let csvString = try? String(contentsOf: fileUrl) else {
            throw FileCacheError.failedRead
        }
        
        guard let parsedTodoItems = csvString
            .components(separatedBy: "\n")
            .map({ TodoItem.parse(csv: $0) }) as? [TodoItem] else {
            throw FileCacheError.failedDeserialization
        }
        
        todoItems = parsedTodoItems
    }
}
