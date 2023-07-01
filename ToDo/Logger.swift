//
//  Logger.swift
//  ToDo
//
//  Created by ios_developer on 01.07.2023.
//

import Foundation
import CocoaLumberjackSwift

class Logger {
    static let sharedInstance = Logger()

    private let fileLogger: DDFileLogger

    private init() {
        fileLogger = DDFileLogger()
        fileLogger.rollingFrequency = TimeInterval(60*60*24)
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7

        DDLog.add(DDOSLogger.sharedInstance, with: .debug)
        DDLog.add(fileLogger, with: .warning)
    }

    func logInfo(_ message: String) {
        DDLogInfo(message)
    }

    func logError(_ message: String) {
        DDLogError(message)
    }
}
