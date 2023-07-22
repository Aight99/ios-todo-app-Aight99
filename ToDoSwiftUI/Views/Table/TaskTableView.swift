//
//  TaskTableView.swift
//  ToDoSwiftUI
//
//  Created by ios_developer on 22.07.2023.
//

import SwiftUI

struct TaskTableView: View {

    @State private var selectedTodo: TodoItem?
    @State private var showModal = false
    private let fileCache = FileCache()

    var body: some View {
        ZStack {
            NavigationView {
                List {
                    Section {
                        ForEach(fileCache.sortedItems) { todo in
                            TaskCellView(todo: todo)
                                .padding(.trailing, Constants.horizontalPadding)
                                .padding(.top, Constants.verticalPadding)
                                .padding(.bottom, Constants.verticalPadding)
                                .onTapGesture {
                                    selectedTodo = todo
                                    showModal = true
                                }
                            .swipeActions(edge: .leading) {
                                Button() {
                                    print("Готово")
                                } label: {
                                    Label("Выполнить", systemImage: SfSymbolNames.circleChecked)
                                }
                                .tint(Color(ColorNames.Main.green))
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    print("Удоли")
                                } label: {
                                    Label("Удалить", systemImage: SfSymbolNames.trash)
                                }
                            }
                        }
                    } header: {
                        HStack {
                            Text("Выполнено - \(fileCache.completedCount)")
                            Spacer()
                            Text("Скрыть")
                                .foregroundColor(Color(ColorNames.Main.blue))
                        }
                        .font(.subheadline)
                        .padding(.bottom, 6)
                    }
                    .textCase(nil)
                }
                .background(Color(ColorNames.Back.primary))
                .scrollContentBackground(.hidden)
                .navigationTitle("ᅠ   Мои дела")
                .navigationBarTitleDisplayMode(.large)
            }
            .sheet(isPresented: $showModal) {
                TaskDetailView(todo: selectedTodo ?? TodoItem())
            }
            VStack {
                Spacer()
                Circle()
                    .fill(Color.blue)
                    .frame(width: Constants.addButtonSize, height: Constants.addButtonSize)
                    .shadow(radius: 5, y: 5)
                    .overlay(
                        Image(systemName: SfSymbolNames.plus)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 22, height: 22)
                            .fontWeight(.bold)
                    )
                    .onTapGesture {
                        selectedTodo = TodoItem()
                        showModal = true
                    }

            }
        }

    }
}

struct TaskTableView_Previews: PreviewProvider {
    static var previews: some View {
        TaskTableView()
    }
}

fileprivate enum Constants {
    static let verticalPadding: CGFloat = 7
    static let horizontalPadding: CGFloat = 16
    static let addButtonSize: CGFloat = 44
}
