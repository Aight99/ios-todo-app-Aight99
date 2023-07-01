//
//  TaskTableViewCell.swift
//  ToDo
//
//  Created by ios_developer on 01.07.2023.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    static let id = "TaskCellHeader"
    private(set) var todoId = ""

    private lazy var checkedCircleView: UIImageView = {
        let image = UIImage(systemName: SfSymbolNames.circleChecked)
        let view = UIImageView(image: image)
        view.tintColor = Colors.Main.green
        view.contentMode = .scaleAspectFill
        return view
    }()

    private lazy var uncheckedCircleView: UIImageView = {
        let image = UIImage(systemName: SfSymbolNames.circle)
        let view = UIImageView(image: image)
        view.tintColor = Colors.Support.separator
        view.contentMode = .scaleAspectFill
        return view
    }()

    private lazy var importantCircleView: UIImageView = {
        let image = UIImage(systemName: SfSymbolNames.circle)
        let view = UIImageView(image: image)
        view.tintColor = Colors.Main.red
        view.contentMode = .scaleAspectFill
        return view
    }()

    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 4
        stackView.addArrangedSubview(titleView)
        stackView.addArrangedSubview(deadlineView)
        return stackView
    }()

    private lazy var titleView: UILabel = {
        let view = UILabel()
        view.textColor = Colors.Label.primary
        view.font = Fonts.body
        return view
    }()

    private lazy var deadlineView: UILabel = {
        let view = UILabel()
        view.textColor = Colors.Label.tertiary
        view.font = Fonts.subhead
        view.isHidden = true
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return view
    }()

    private lazy var arrowView: UIImageView = {
        let image = UIImage(systemName: SfSymbolNames.chevronForward)
        let view = UIImageView(image: image)
        view.tintColor = Colors.Main.gray
        view.contentMode = .scaleAspectFill
        return view
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(checkedCircleView)
        addSubview(uncheckedCircleView)
        addSubview(importantCircleView)
        addSubview(titleStackView)
        addSubview(arrowView)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with todo: TodoItem) {
        titleView.attributedText = NSAttributedString()
        titleView.textColor = Colors.Label.primary
        todoId = todo.id
        deadlineView.isHidden = true
        uncheckedCircleView.isHidden = true
        checkedCircleView.isHidden = true
        importantCircleView.isHidden = true

        if todo.isComplete {
            let attributeString = NSMutableAttributedString(string: todo.text)
            attributeString.addAttribute(
                NSAttributedString.Key.strikethroughStyle,
                value: 2,
                range: NSRange(location: 0, length: attributeString.length)
            )
            titleView.attributedText = attributeString
            titleView.textColor = Colors.Label.tertiary
            checkedCircleView.isHidden = false
            return
        }

        titleView.text = todo.text
        if let deadline = todo.deadline {
            let imageAttachment = NSTextAttachment()
            let image = UIImage(systemName: SfSymbolNames.calendar)?.withTintColor(Colors.Label.tertiary)
            imageAttachment.image = image
            let deadlineString = NSMutableAttributedString(attachment: imageAttachment)
            deadlineString.append(NSAttributedString(string: deadline.deadlineFormat))
            deadlineView.attributedText = deadlineString
            deadlineView.isHidden = false
        }

        if todo.importance == .important {
            titleView.text = "‼️" + (titleView.text ?? "")
            importantCircleView.isHidden = false
        } else {
            uncheckedCircleView.isHidden = false
        }
    }

    private func setupConstraints() {
        checkedCircleView.translatesAutoresizingMaskIntoConstraints = false
        uncheckedCircleView.translatesAutoresizingMaskIntoConstraints = false
        importantCircleView.translatesAutoresizingMaskIntoConstraints = false
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        arrowView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            checkedCircleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkedCircleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
            checkedCircleView.widthAnchor.constraint(equalToConstant: Constants.circleDiameter),
            checkedCircleView.heightAnchor.constraint(equalToConstant: Constants.circleDiameter),

            uncheckedCircleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            uncheckedCircleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
            uncheckedCircleView.widthAnchor.constraint(equalToConstant: Constants.circleDiameter),
            uncheckedCircleView.heightAnchor.constraint(equalToConstant: Constants.circleDiameter),

            importantCircleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            importantCircleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
            importantCircleView.widthAnchor.constraint(equalToConstant: Constants.circleDiameter),
            importantCircleView.heightAnchor.constraint(equalToConstant: Constants.circleDiameter),
            
            titleStackView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.verticalPadding),
            titleStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalPadding),
            titleStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding + Constants.circleDiameter + Constants.itemsSpacing),
            titleStackView.trailingAnchor.constraint(equalTo: arrowView.trailingAnchor, constant: -Constants.itemsSpacing),

            arrowView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
            arrowView.widthAnchor.constraint(equalToConstant: Constants.arrowWidth),
            arrowView.heightAnchor.constraint(equalToConstant: Constants.arrowHeight),

        ])
    }

    private enum Constants {
        static let verticalPadding: CGFloat = 16
        static let horizontalPadding: CGFloat = 16
        static let itemsSpacing: CGFloat = 12
        static let circleDiameter: CGFloat = 24
        static let arrowHeight: CGFloat = 14
        static let arrowWidth: CGFloat = 10
    }
}
