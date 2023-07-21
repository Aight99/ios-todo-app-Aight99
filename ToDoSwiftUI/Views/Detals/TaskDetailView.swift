//
//  TaskDetailView.swift
//  ToDoSwiftUI
//
//  Created by ios_developer on 22.07.2023.
//

import SwiftUI

struct TaskDetailView: View {

    @State private var taskText = ""

    var body: some View {
        VStack {
//            ZStack(alignment: .leading) {
//                TextEditor(text: $taskText)
//                if taskText.isEmpty {
//                    Text("Что нужно сделать?")
//                        .opacity(0.4)
//                        .padding()
//                }
//            }
//            .frame(minHeight: 120)
            TextField("Что нужно сделать?", text: $taskText, axis: .vertical)
                .padding()
                .lineLimit(10)
                .background(Color(ColorNames.Back.secondary))
                .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))

            SettingsView()
                .background(Color(ColorNames.Back.secondary))
                .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
            Button(action: deleteTask) {
                Text("Удалить")
                    .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
                    .foregroundColor(Color(ColorNames.Main.red))
                    .background(Color(ColorNames.Back.secondary))
                    .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
            }
            Spacer()
        }
        .padding()
        .background(Color(ColorNames.Back.primary))
    }

    func deleteTask() {
        print("Удолено")
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView()
    }
}

fileprivate enum Constants {
    static let cornerRadius: CGFloat = 16
}
