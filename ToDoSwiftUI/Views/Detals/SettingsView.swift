//
//  SettingsView.swift
//  ToDoSwiftUI
//
//  Created by ios_developer on 22.07.2023.
//

import SwiftUI

let importanceList = ["💤", "нет", "‼️"]

struct SettingsView: View {
    @State private var isCalendarHidden = true
    @State private var isDeadlineEnabled = false
    @State private var selectedDeadline = Date.tomorrow
    @State private var selectedImportance = importanceList[1]

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

    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
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
