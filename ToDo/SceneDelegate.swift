//
//  SceneDelegate.swift
//  ToDo
//
//  Created by ios_developer on 15.06.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // Пока что нет корневого экрана и графа зависимостей, поэтому я оставлю пока здесь
    let fileName = "helpMe.json"
    var fileCache = FileCache()


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        loadTodoItems()
        let todo = fileCache.todoItems.first!.value
        let taskDetailVC = TaskDetailController(todoItem: todo)
        taskDetailVC.delegate = self
        let navigationController = UINavigationController(rootViewController: taskDetailVC)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    private func loadTodoItems() {
        do {
            try fileCache.loadTodoItemsFromJson(filename: fileName)
        } catch {
            fileCache.add(todo: TodoItem())
        }
    }
}

extension SceneDelegate: TaskDetailDelegate {
    func save(todo: TodoItem) {
        fileCache.add(todo: todo)
        try? fileCache.saveJsonOnDevice(filename: fileName)
    }

    func delete(id: String) {
        fileCache.remove(todoId: id)
        fileCache.add(todo: TodoItem())
        try? fileCache.saveJsonOnDevice(filename: fileName)
    }


}

