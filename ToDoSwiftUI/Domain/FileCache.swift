//
//  FileCache.swift
//  ToDoSwiftUI
//
//  Created by ios_developer on 22.07.2023.
//

import Foundation

final class FileCache {

    private(set) var todoItems: [String: TodoItem] = FileCache.getDummyTodos()

    var sortedItems: [TodoItem] {
        return todoItems.sorted { $0.value.creationDate > $1.value.creationDate }.map { $0.value }
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
    static func getDummyTodos() -> [String: TodoItem] {
        let todoList = [
            TodoItem(text: "Купить ананас", importance: .important, isComplete: true),
            TodoItem(text: "Купить мельницу", importance: .unimportant, isComplete: false),
            TodoItem(text: "Раскатать тесто", importance: .important, isComplete: false),
            TodoItem(text: "Испечь пиццку", importance: .normal, isComplete: false),
        ]

        return todoList.reduce(into: [:]) { result, todo in
            result[todo.id] = todo
        }
    }
}
