//
//  TaskCellView.swift
//  ToDoSwiftUI
//
//  Created by ios_developer on 22.07.2023.
//

import SwiftUI

struct TaskCellView: View {
    let todo: TodoItem

    var body: some View {
        HStack {
            if todo.isComplete {
                Image(systemName: SfSymbolNames.circleChecked)
                    .resizable()
                    .frame(width: Constants.circleDiameter, height: Constants.circleDiameter)
                    .foregroundColor(Color(ColorNames.Main.green))
            } else if todo.importance == .important {
                Image(systemName: SfSymbolNames.circle)
                    .resizable()
                    .frame(width: Constants.circleDiameter, height: Constants.circleDiameter)
                    .foregroundColor(Color(ColorNames.Main.red))
            } else {
                Image(systemName: SfSymbolNames.circle)
                    .resizable()
                    .frame(width: Constants.circleDiameter, height: Constants.circleDiameter)
                    .foregroundColor(Color(ColorNames.Label.tertiary))
            }

            HStack {
                VStack(alignment: .leading) {
                    Text(
                        todo.importance == .important && !todo.isComplete
                        ? "‼️" + todo.text
                        : todo.text
                    )
                    .strikethrough(todo.isComplete)
                    .foregroundColor(todo.isComplete ? Color(ColorNames.Label.tertiary) : Color(ColorNames.Label.primary))
                    if !todo.isComplete, let deadline = todo.deadline {
                        HStack {
                            Image(systemName: SfSymbolNames.calendar)
                            Text(deadline.deadlineFormat)
                        }
                        .foregroundColor(Color(ColorNames.Main.gray))
                        .font(.subheadline)
                    }
                }
            }
            Spacer()
            Image(systemName: SfSymbolNames.chevronForward)
                .foregroundColor(Color(ColorNames.Label.tertiary))
        }
    }
}

struct TaskCellView_Previews: PreviewProvider {
    static var previews: some View {
        TaskCellView(todo: TodoItem(text: "Kupit cheese", importance: .important, deadline: .now, isComplete: false, creationDate: .now, modificationDate: .now))
            .background(Color(ColorNames.Back.secondary))
            .padding()
            .shadow(radius: 10)
    }
}

fileprivate enum Constants {
    static let verticalPadding: CGFloat = 16
    static let horizontalPadding: CGFloat = 16
    static let itemsSpacing: CGFloat = 12
    static let circleDiameter: CGFloat = 24
    static let arrowHeight: CGFloat = 14
    static let arrowWidth: CGFloat = 10
}
