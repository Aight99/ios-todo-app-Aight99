//
//  Utils.swift
//  ToDoSwiftUI
//
//  Created by ios_developer on 22.07.2023.
//

import Foundation

extension Date {

    static var tomorrow: Date {
        Calendar.current.date(byAdding: DateComponents(day: 1), to: Date())!
    }

    var deadlineFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd MMMM yyyy")
        return dateFormatter.string(from: self)
    }
}
