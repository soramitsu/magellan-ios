//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/
import Foundation
import OHHTTPStubs


final class Mocks {
    
    static func mockAPI() {
        mock(path: "/paymentservice/api/v1/merchants/types", filename: "types.json")
        mock(path: "/paymentservice/api/v1/merchants/{placeId}", filename: "placeInfo.json")
        mock(path: "/paymentservice/api/v1/merchants", filename: "placesList.json")
    }
    
    static func mock(path: String, filename: String) {
        stub(condition: isPath(path), response: responseStub(filename))
    }
    
    private static func mock(path: String, filename: String, params: [String: String]) {
        stub(condition: isPath(path) && containsQueryParams(params),
             response: self.responseStub(filename))
    }
    
    private static func responseStub(_ filename: String) -> HTTPStubsResponseBlock {
        return { (_) -> HTTPStubsResponse in
            guard let path = OHPathForFileInBundle(filename, Bundle.main) else {
                return HTTPStubsResponse(jsonObject: [:], statusCode: 404, headers: nil)
            }
            return HTTPStubsResponse(
                fileAtPath: path,
                statusCode: 200,
                headers: ["Content-Type": "application/json"]
            )
        }
    }
    
}
