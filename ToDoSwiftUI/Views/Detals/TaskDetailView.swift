//
//  TaskDetailView.swift
//  ToDoSwiftUI
//
//  Created by ios_developer on 22.07.2023.
//

import SwiftUI

struct TaskDetailView: View {

    @State private var taskText = ""
    let todo: TodoItem

    init(todo: TodoItem) {
        self.todo = todo
    }

    var body: some View {
        NavigationView {
            VStack {
                TextField("Что нужно сделать?", text: $taskText, axis: .vertical)
                    .padding()
                    .lineLimit(10)
                    .background(Color(ColorNames.Back.secondary))
                    .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))

                SettingsView(todo: todo)
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
            .navigationBarTitle("Дело")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        print("Галя, отмена")
                    }) {
                        Text("Отменить")
                    },
                trailing:
                    Button(action: {
                        print("Сохранено")
                    }) {
                        Text("Сохранить")
                            .fontWeight(.semibold)
                    }
            )
            .onAppear() {
                setup()
            }
        }
    }

    func deleteTask() {
        print("Удолено")
    }

    private func setup() {
        self.taskText = todo.text
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView(todo: TodoItem())
    }
}

fileprivate enum Constants {
    static let cornerRadius: CGFloat = 16
}
