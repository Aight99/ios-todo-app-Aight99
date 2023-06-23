//
//  SceneDelegate.swift
//  ToDo
//
//  Created by ios_developer on 15.06.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

//        let text = "Купить сыр"
        let longText = """
        Хлыстобулыстрафия синтезирует акселерометрический ликвидатор с метафизическими свойствами, который увеличивает интенсивность электромагнитного поля внутри коробки из бумаги, не позволяя при этом кирпичным гусеницам попасть внутрь. Одновременно с этим, телепатический нейронный синапс управляет квантовыми прыжками с векторной модуляцией, создавая космический эффект на поверхности лампочки.

        Атомарный гипноз вызывает у летающих слоников гиперактивный метаболизм, что приводит к ускоренному распаду молекул кремния в ультрафиолетовой зоне. Это, в свою очередь, вызывает дифракционный рефлекс, который изменяет цветовую гамму рядом стоящих кроликов и превращает их в красивых фламинго. Однако, при этом происходит обратная реакция, которая превращает молекулы воды в пар, и тогда все кролики превращаются в обычные кролики.
        """
        let todoMock = TodoItem(text: longText, importance: .normal, isComplete: false)

        let taskDetailVC = TaskDetailController(todoItem: todoMock)
        let navigationController = UINavigationController(rootViewController: taskDetailVC)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

