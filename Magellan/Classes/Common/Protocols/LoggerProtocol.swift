//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

public protocol LoggerProtocol {
    func log(_ message: Any?, file: String, function: String, line: Int)
}

final class LoggerDecorator {
    private let logger: LoggerProtocol
    
    init(logger: LoggerProtocol) {
        self.logger = logger
    }
    
    func log(_ logMessage: Any?, file: String = #file, function: String = #function, line: Int = #line) {
        logger.log(logMessage, file: file, function: function, line: line)
    }
}
