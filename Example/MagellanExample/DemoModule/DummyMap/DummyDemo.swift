/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import Magellan

class DummyDemo: DemoFactoryProtocol {
    var title: String {
        return "Dummy Demo"
    }
    
    func setupDemo(with completionBlock: @escaping DemoCompletionBlock) throws -> UIViewController {
        let testKey = "AIzaSyA-hfkkknmSEx4BR1WsnlrydPpgYncnKkg"
        let baseUrl = URL(string: "https://pgateway1.s1.dev.bakong.soramitsu.co.jp")!
        let networkResolver = NetworkResolver(baseUrl: baseUrl)
        Mocks.mockAPI()
        return MaggelanBuilder(key: testKey).build(networkResolver: networkResolver)
    }
}
