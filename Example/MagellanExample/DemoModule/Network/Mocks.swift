//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/
import Foundation
import OHHTTPStubs


final class Mocks {
        
    static func mockAPI(_ resolver: NetworkResolver) {
        mock(path: resolver.makePathComponent(for: .categories), filename: "types.json")
        mock(path: resolver.makePathComponent(for: .placeInfo), filename: "placeInfo.json")
        mock(path: resolver.makePathComponent(for: .placesList), filename: "placesList.json")
        mock(path: resolver.makePathComponent(for: .placeAllReviews), filename: "reviewsAll.json")
        mock(path: resolver.makePathComponent(for: .placeLastReviews), filename: "reviewsLast.json")
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
