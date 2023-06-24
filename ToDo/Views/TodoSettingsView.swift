//
//  TodoSettingsView.swift
//  ToDo
//
//  Created by ios_developer on 24.06.2023.
//

import UIKit

class TodoSettingsView: UIStackView {

    let todoItem: TodoItem

    private var calendarSegment = [UIView]()
    private var segmentsView: UISegmentedControl?
    private var deadlineLabel: UILabel?
    private(set) var deadline: Date?

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
        self.segmentsView = segmentsView

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
        deadlineLabel = sublabel
        sublabel.font = Fonts.footnote
        sublabel.textColor = Colors.Main.blue
        sublabel.isHidden = true

        labelStack.addArrangedSubview(label)
        labelStack.addArrangedSubview(sublabel)

        let switchView = UISwitch()
        if let existingDeadline = todoItem.deadline {
            sublabel.text = formatDate(existingDeadline)
            switchView.isOn = true
            sublabel.isHidden = false
        }
        switchView.addTarget(self, action: #selector(switchDeadline(_:)), for: .valueChanged)

        view.addArrangedSubview(labelStack)
        view.addArrangedSubview(switchView)
        return view
    }()

    private lazy var datePickerView: UIDatePicker = {
        let view = UIDatePicker()
        view.datePickerMode = .date
        view.preferredDatePickerStyle = .inline
        view.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
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
        calendarSegment.append(hiddenDivider)
        calendarSegment.append(datePickerView)

        addArrangedSubview(hiddenDivider)
        addArrangedSubview(datePickerView)

        toggleCalendarViews()
    }

    required init(coder: NSCoder) {
        fatalError("Interface Builder is not supported")
    }

    var importance: Importance {
        guard let segmentsView = segmentsView else {
            return .normal
        }
        switch segmentsView.selectedSegmentIndex {
        case 0: return .unimportant
        case 1: return .normal
        case 2: return .important
        default: return .normal
        }
    }

    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        let date = sender.date
        let dateString = formatDate(date)
        deadlineLabel?.text = dateString
        deadlineLabel?.isHidden = false
        deadline = sender.date
        toggleCalendarViews()
    }

    @objc private func switchDeadline(_ sender: UISwitch) {
        if sender.isOn {
            toggleCalendarViews()
        } else {
            if !calendarSegment[0].isHidden {
                toggleCalendarViews()
            }
            deadlineLabel?.isHidden = true
        }
    }

    private func toggleCalendarViews() {
        for view in calendarSegment {
            UIView.animate(withDuration: 0.2) {
                view.isHidden = !view.isHidden
            }
        }
    }

    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd MMMM yyyy")
        return dateFormatter.string(from: date)
    }

    private enum Constants {
        static let dividerHeight: CGFloat = 0.5
        static let segmentsHeight: CGFloat = 36
        static let verticalPadding: CGFloat = 10
        static let horizontalPadding: CGFloat = 16
    }
    
}
