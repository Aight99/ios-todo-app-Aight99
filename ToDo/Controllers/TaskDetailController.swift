//
//  TaskDetailController.swift
//  ToDo
//
//  Created by ios_developer on 15.06.2023.
//

import UIKit

protocol TaskDetailDelegate: AnyObject {
    func save(todo: TodoItem)
    func delete(id: String)
}


class TaskDetailController: UIViewController {

    let todoItem: TodoItem
    weak var delegate: TaskDetailDelegate?

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.layoutMargins = UIEdgeInsets(
            top: Constants.stackViewSpacing,
            left: Constants.stackViewSpacing,
            bottom: Constants.stackViewSpacing,
            right: Constants.stackViewSpacing
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = Constants.stackViewSpacing
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var textView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.attributedText = Fonts.getAttributedString(style: .body, text: todoItem.text)
        textView.textColor = Colors.Label.primary
        textView.backgroundColor = Colors.Back.secondary
        textView.textContainerInset = UIEdgeInsets(
            top: Constants.textViewVerticalPadding,
            left: Constants.textViewHorizontalPadding,
            bottom: Constants.textViewVerticalPadding,
            right: Constants.textViewHorizontalPadding
        )
        textView.layer.cornerRadius = Constants.cornerRadius
        textView.isScrollEnabled = false
        return textView
    }()

    private lazy var deleteButtonView: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(Colors.Main.red, for: .normal)
        button.titleLabel?.font = Fonts.body
        button.backgroundColor = Colors.Back.secondary
        button.layer.cornerRadius = Constants.cornerRadius
        button.contentEdgeInsets = UIEdgeInsets(
            top: Constants.buttonContentPadding,
            left: Constants.buttonContentPadding,
            bottom: Constants.buttonContentPadding,
            right: Constants.buttonContentPadding
        )
        button.addTarget(self, action: #selector(deleteTodo), for: .touchUpInside)
        return button
    }()

    private lazy var settingsView: TodoSettingsView = {
        let settings = TodoSettingsView(todoItem: todoItem)
        settings.backgroundColor = Colors.Back.secondary
        settings.layer.cornerRadius = Constants.cornerRadius
        return settings
    }()

    init(todoItem: TodoItem) {
        self.todoItem = todoItem
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Interface Builder is not supported")
    }

    override func loadView() {
        view = scrollView
        view.addSubview(stackView)
        stackView.addArrangedSubview(textView)
        stackView.addArrangedSubview(settingsView)
        stackView.addArrangedSubview(deleteButtonView)
        setupConstraints()
        setupNavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.Back.primary
    }

    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor),
        ])
    }

    private func setupNavigationBar() {
        navigationItem.title = "Дело"
        let cancelItem = UIBarButtonItem(
            title: "Отменить",
            style: .plain,
            target: nil,
            action: nil
        )
        let saveItem = UIBarButtonItem(
            title: "Сохранить",
            style: .done,
            target: nil,
            action: nil
        )
        saveItem.target = self
        saveItem.action = #selector(saveTodo)
        cancelItem.target = self
        cancelItem.action = #selector(closeModal)
        navigationItem.leftBarButtonItem = cancelItem
        navigationItem.rightBarButtonItem = saveItem
    }

    @objc private func saveTodo() {
        let newImportance = settingsView.importance
        let newDeadline: Date? = settingsView.deadline
        let newTodo = TodoItem(
            id: todoItem.id,
            text: textView.text,
            importance: newImportance,
            deadline: newDeadline,
            isComplete: todoItem.isComplete,
            creationDate: todoItem.creationDate,
            modificationDate: Date()
        )
        delegate?.save(todo: newTodo)
        closeModal()
    }

    @objc private func closeModal() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }

    @objc private func deleteTodo() {
        delegate?.delete(id: todoItem.id)
    }

    private enum Constants {
        static let textViewVerticalPadding: CGFloat = 12
        static let textViewHorizontalPadding: CGFloat = 16
        static let stackViewSpacing: CGFloat = 16
        static let cornerRadius: CGFloat = 16
        static let buttonContentPadding: CGFloat = 16
    }
}

