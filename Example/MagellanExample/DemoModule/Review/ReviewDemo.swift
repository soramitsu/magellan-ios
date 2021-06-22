//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import Magellan

struct ReviewDemo: DemoFactoryProtocol {
    
    var title: String { "Reviews Demo" }
    
    func setupDemo(with completionBlock: @escaping DemoCompletionBlock) throws -> UIViewController {
        UIFont.registerFonts()
        guard let baseUrl = URL(string: "https://pgateway1.s1.dev.bakong.soramitsu.co.jp") else { throw URLError(.badURL) }
        let networkResolver = NetworkResolver(baseUrl: baseUrl)
        Mocks.mockAPI(networkResolver)
        return ReviewAssembly.assembly(with: networkResolver)
    }
}
