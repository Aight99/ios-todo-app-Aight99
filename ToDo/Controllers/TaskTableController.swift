//
//  TaskTableController.swift
//  ToDo
//
//  Created by ios_developer on 01.07.2023.
//

import UIKit

class TaskTableController: UIViewController {

    let fileName = "helpMeHelpMe.json"
    private var fileCache = FileCache()

    private lazy var taskTable: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.id)
        return table
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton(frame: .zero)
        let image = UIImage(systemName: SfSymbolNames.plus)
        button.setImage(image, for: .normal)
        button.tintColor = Colors.Back.secondary
        button.backgroundColor = Colors.Main.blue
        button.layer.cornerRadius = 22
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowRadius = 7
        button.addTarget(self, action: #selector(startTodoCreation), for: .touchUpInside)
        return button
    }()

    override func loadView() {
        view = UIView()
        view.addSubview(taskTable)
        view.addSubview(addButton)
        taskTable.delegate = self
        taskTable.dataSource = self
        setupConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTodoItems()

        setupNavigationBar()
        view.backgroundColor = Colors.Back.iOSPrimary
    }

    private func setupConstraints() {
        taskTable.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            taskTable.topAnchor.constraint(equalTo: view.topAnchor),
            taskTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            taskTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            taskTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 44),
            addButton.widthAnchor.constraint(equalToConstant: 44),
        ])
    }

    private func setupNavigationBar() {
        title = "Мои дела"
        navigationController?.navigationBar.prefersLargeTitles = true
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 16
        let largeTitleAttributes: [NSAttributedString.Key: Any] = [
            .font: Fonts.largeTitle,
            .paragraphStyle: paragraphStyle,
        ]
        navigationController?.navigationBar.largeTitleTextAttributes = largeTitleAttributes
    }

    @objc private func startTodoCreation() {
        let newTodo = TodoItem()
        presentModal(todo: newTodo)
    }

    private func presentModal(todo: TodoItem) {
        let taskDetailVC = TaskDetailController(todoItem: todo)
        taskDetailVC.delegate = self
        let navigationController = UINavigationController(rootViewController: taskDetailVC)
        present(navigationController, animated: true)
    }

    private func loadTodoItems() {
        do {
            try fileCache.loadTodoItemsFromJson(filename: fileName)
        } catch {
            fileCache.add(todo: TodoItem())
        }
    }
}

// TODO: Update current table view content
extension TaskTableController: TaskDetailDelegate {
    func save(todo: TodoItem) {
        fileCache.add(todo: todo)
        try? fileCache.saveJsonOnDevice(filename: fileName)
        taskTable.reloadData()
    }

    func delete(id: String) {
        fileCache.remove(todoId: id)
        try? fileCache.saveJsonOnDevice(filename: fileName)
        taskTable.reloadData()
    }
}

extension TaskTableController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileCache.todoItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.id, for: indexPath)
        guard let taskCell = cell as? TaskTableViewCell else {
            fatalError("Cannot dequeue TaskTableViewCell")
        }
        let todo = fileCache.sortedItems[indexPath.row]
        taskCell.configure(with: todo)
        return taskCell
    }
}

extension TaskTableController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let todo = fileCache.sortedItems[indexPath.row]
        presentModal(todo: todo)
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell else {
            return nil
        }

        let deleteAction = UIContextualAction(style: .destructive, title:  "", handler: {
            [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            self.delete(id: cell.todoId)
        })
        deleteAction.image = UIImage(systemName: SfSymbolNames.trash)
        deleteAction.backgroundColor = Colors.Main.red

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell else {
            return nil
        }

        let doneAction = UIContextualAction(style: .normal, title:  "", handler: {
            [weak self] (action, view, completionHandler) in
            guard let self = self, let todo = self.fileCache.todoItems[cell.todoId] else { return }
            self.save(todo: todo.oppositeCompletion)
        })
        doneAction.image = UIImage(systemName: SfSymbolNames.circleChecked)
        doneAction.backgroundColor = Colors.Main.green

        let configuration = UISwipeActionsConfiguration(actions: [doneAction])
        return configuration
    }
}
