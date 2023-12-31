//
//  SettingsView.swift
//  ToDoSwiftUI
//
//  Created by ios_developer on 22.07.2023.
//

import SwiftUI

struct SettingsView: View {
    @State private var isCalendarHidden = true
    @State private var isDeadlineEnabled: Bool = false
    @State private var selectedDeadline: Date = Date.tomorrow
    @State private var selectedImportance: String = ""
    let importanceList = ["💤", "нет", "‼️"]

    let todo: TodoItem

    init(todo: TodoItem) {
        self.todo = todo
    }

    var body: some View {
        VStack {
            HStack {
                Text("Важность")
                Spacer()
                Picker("Выбор важности", selection: $selectedImportance) {
                    ForEach(importanceList, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                .frame(
                    width: Constants.segmentsWidth,
                    height: Constants.segmentsHeight,
                    alignment: .center
                )
            }
            .padding(.leading, Constants.horizontalPadding)
            .padding(.trailing, Constants.horizontalPadding)
            .padding(.top, Constants.verticalPadding)

            Divider()
                .padding(.leading, Constants.horizontalPadding)
                .padding(.trailing, Constants.horizontalPadding)

            HStack {
                VStack(alignment: .leading) {
                    Text("Сделать до")
                    if isDeadlineEnabled {
                        Text(selectedDeadline.deadlineFormat)
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundColor(Color(ColorNames.Main.blue))
                            .onTapGesture {
                                isCalendarHidden.toggle()
                            }
                    }
                }
                Spacer()
                Toggle("", isOn: $isDeadlineEnabled)
                    .labelsHidden()
            }
            .padding(.leading, Constants.horizontalPadding)
            .padding(.trailing, Constants.horizontalPadding)
            .padding(.bottom, isCalendarHidden ? Constants.verticalPadding : 0)

            if !isCalendarHidden {
                Divider()
                    .padding(.leading, Constants.horizontalPadding)
                    .padding(.trailing, Constants.horizontalPadding)
                HStack {
                    DatePicker("Дедлайн", selection: $selectedDeadline, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .onChange(of: selectedDeadline) { newValue in
                            isCalendarHidden = true
                        }
                }
                .padding(.leading, Constants.horizontalPadding)
                .padding(.trailing, Constants.horizontalPadding)
                .padding(.bottom, Constants.verticalPadding)
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear() {
            setup()
        }

    }

    private func setup() {
        selectedImportance = {
            switch todo.importance {
            case .unimportant: return importanceList[0]
            case .normal: return importanceList[1]
            case .important: return importanceList[2]
            }
        }()
        if let deadline = todo.deadline {
            selectedDeadline = deadline
            isDeadlineEnabled = true
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(todo: TodoItem())
            .background(Color(ColorNames.Back.secondary))
            .padding()
            .shadow(radius: 10)

    }
}

fileprivate enum Constants {
    static let segmentsWidth: CGFloat = 150
    static let segmentsHeight: CGFloat = 36
    static let verticalPadding: CGFloat = 10
    static let horizontalPadding: CGFloat = 16
}
