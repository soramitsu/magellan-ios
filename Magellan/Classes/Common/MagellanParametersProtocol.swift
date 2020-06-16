//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

public protocol MagellanParametersProtocol {
    var searchMinimumLettersCount: Int { get }
}

final class DefaultMagellanParameters: MagellanParametersProtocol {
    var searchMinimumLettersCount: Int {
        return 2
    }
}
