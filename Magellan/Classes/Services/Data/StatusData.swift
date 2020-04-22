/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation

enum ResultDataError: Error {
    case missingStatusField
}

struct StatusData: Decodable {
    let code: Int
    let errorCode: String?
    let error: String?
    let warning: String?

    var isSuccess: Bool {
        return code == 0
    }
}

struct ResultData<ResultType> where ResultType: Decodable {
    let status: StatusData
    let result: ResultType?
}

public struct DynamicCodingKey: CodingKey {
    public var stringValue: String

    public init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = Int(stringValue)
    }

    public var intValue: Int?

    public init?(intValue: Int) {
        self.intValue = intValue
        self.stringValue = String(intValue)
    }
}

extension ResultData: Decodable {
    enum CodingKeys: String, CodingKey {
        case status
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKey.self)

        guard let statusKey = DynamicCodingKey(stringValue: CodingKeys.status.rawValue) else {
            throw ResultDataError.missingStatusField
        }

        status = try container.decode(StatusData.self, forKey: statusKey)
        let resultKey = "data"
        
        if let resultKey = container.allKeys.first(where: { $0.stringValue == resultKey }) {
            result = try container.decode(ResultType.self, forKey: resultKey)
        } else {
            result = nil
        }
    }
}
