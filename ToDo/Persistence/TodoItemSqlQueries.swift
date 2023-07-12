//
//  TodoItemSqlQueries.swift
//  ToDo
//
//  Created by ios_developer on 13.07.2023.
//

import Foundation

// Насколько я понял, в SQLite.swift есть типизированные запросы через Expression,
// но по заданию нужно сделать именно перевод в String-запрос
// Если не прав, то жду комменты :D

extension TodoItem {
    var sqlReplaceStatement: String {
        let columns = """
            \(SqlTableKeys.id),
            \(SqlTableKeys.text),
            \(SqlTableKeys.importance),
            \(SqlTableKeys.deadline),
            \(SqlTableKeys.isComplete),
            \(SqlTableKeys.creationDate),
            \(SqlTableKeys.modificationDate)
            """
        let values = """
            \(id.quoted),
            \(text.quoted),
            \(importance.rawValue.quoted),
            \(deadline?.timeIntervalSince1970.stringValue ?? "NULL"),
            \(isComplete.intValue),
            \(creationDate.timeIntervalSince1970),
            \(modificationDate?.timeIntervalSince1970.stringValue ?? "NULL")
            """
        let query = """
            REPLACE INTO \(SqlTableKeys.tableName)
            (\(columns))
            VALUES
            (\(values))
            """
        return query
    }

    var sqlInsertStatement: String {
        let columns = """
            \(SqlTableKeys.id),
            \(SqlTableKeys.text),
            \(SqlTableKeys.importance),
            \(SqlTableKeys.deadline),
            \(SqlTableKeys.isComplete),
            \(SqlTableKeys.creationDate),
            \(SqlTableKeys.modificationDate)
            """
        let values = """
            \(id.quoted),
            \(text.quoted),
            \(importance.rawValue.quoted),
            \(deadline?.timeIntervalSince1970.stringValue ?? "NULL"),
            \(isComplete.intValue),
            \(creationDate.timeIntervalSince1970),
            \(modificationDate?.timeIntervalSince1970.stringValue ?? "NULL")
            """
        let query = """
            INSERT INTO \(SqlTableKeys.tableName)
            (\(columns))
            VALUES
            (\(values))
            """
        return query
    }

    var sqlUpdateStatement: String {
        let setValues = """
            \(SqlTableKeys.text) = \(text.quoted),
            \(SqlTableKeys.importance) = \(importance.rawValue.quoted),
            \(SqlTableKeys.deadline) = \(deadline?.timeIntervalSince1970.stringValue ?? "NULL"),
            \(SqlTableKeys.isComplete) = \(isComplete.intValue),
            \(SqlTableKeys.modificationDate) = \(modificationDate?.timeIntervalSince1970.stringValue ?? "NULL")
            """
        let query = """
            UPDATE \(SqlTableKeys.tableName)
            SET \(setValues)
            WHERE \(SqlTableKeys.id) = \(id.quoted)
            """
        return query
    }

    var sqlDeleteStatement: String {
        let query = """
            DELETE FROM \(SqlTableKeys.tableName)
            WHERE \(SqlTableKeys.id) = \(id.quoted)
            """
        return query
    }
}
