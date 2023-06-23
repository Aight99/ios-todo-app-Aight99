//
//  TodoSettingsView.swift
//  ToDo
//
//  Created by ios_developer on 24.06.2023.
//

import UIKit

class TodoSettingsView: UIStackView {

    let todoItem: TodoItem

    var viewsToHide = [UIView]()

    private lazy var importanceView: UIView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .center
        view.layoutMargins = UIEdgeInsets(
            top: Constants.verticalPadding,
            left: Constants.horizontalPadding,
            bottom: Constants.verticalPadding,
            right: Constants.horizontalPadding
        )

        let segmentsView = UISegmentedControl(items: [
            "💤", "нет", "‼️",
        ])
        segmentsView.selectedSegmentIndex = {
            switch todoItem.importance {
            case .important: return 2
            case .normal: return 1
            case .unimportant: return 0
            }
        }()

        let label = UILabel()
        label.text = "Важность"
        label.font = Fonts.body
        label.textColor = Colors.Label.primary

        view.addArrangedSubview(label)
        view.addArrangedSubview(segmentsView)
        segmentsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentsView.heightAnchor.constraint(equalToConstant: Constants.segmentsHeight),
        ])
        return view
    }()

    private lazy var deadlineView: UIView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .center
        view.layoutMargins = UIEdgeInsets(
            top: Constants.verticalPadding,
            left: Constants.horizontalPadding,
            bottom: Constants.verticalPadding,
            right: Constants.horizontalPadding
        )

        let labelStack = UIStackView()
        labelStack.axis = .vertical
        labelStack.alignment = .fill
        let label = UILabel()
        label.text = "Сделать до"
        label.font = Fonts.body
        label.textColor = Colors.Label.primary
        let sublabel = UILabel()
        sublabel.text = "2 июня 2021"
        sublabel.font = Fonts.footnote
        sublabel.textColor = Colors.Main.blue
        labelStack.addArrangedSubview(label)
        labelStack.addArrangedSubview(sublabel)
        viewsToHide.append(sublabel)

        let switchView = UISwitch()
        view.addArrangedSubview(labelStack)
        view.addArrangedSubview(switchView)
        return view
    }()

    private lazy var datePickerView: UIDatePicker = {
        let view = UIDatePicker()
        view.datePickerMode = .date
        view.preferredDatePickerStyle = .inline
        return view
    }()

    init(frame: CGRect = .zero, todoItem: TodoItem) {
        self.todoItem = todoItem
        super.init(frame: frame)
        axis = .vertical
        spacing = Constants.verticalPadding
        layoutMargins = UIEdgeInsets(
            top: Constants.verticalPadding,
            left: Constants.horizontalPadding,
            bottom: Constants.verticalPadding,
            right: Constants.horizontalPadding
        )
        isLayoutMarginsRelativeArrangement = true
        addArrangedSubview(importanceView)
        addArrangedSubview(DividerView(height: Constants.dividerHeight))
        addArrangedSubview(deadlineView)

        let hiddenDivider = DividerView(height: Constants.dividerHeight)
        viewsToHide.append(hiddenDivider)
        viewsToHide.append(datePickerView)

        addArrangedSubview(hiddenDivider)
        addArrangedSubview(datePickerView)

        toggleHiddenViews()
    }

    required init(coder: NSCoder) {
        fatalError("Interface Builder is not supported")
    }

    private func toggleHiddenViews() {
        for hide in viewsToHide {
            hide.isHidden = !hide.isHidden
        }
    }

    private enum Constants {
        static let dividerHeight: CGFloat = 0.5
        static let segmentsHeight: CGFloat = 36
        static let verticalPadding: CGFloat = 10
        static let horizontalPadding: CGFloat = 16
    }
    
}
