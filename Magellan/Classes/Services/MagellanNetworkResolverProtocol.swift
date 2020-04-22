//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation
import RobinHood

public protocol MagellanNetworkResolverProtocol {
    func urlTemplate(for type: MagellanRequestType) -> String
    func adapter(for type: MagellanRequestType) -> NetworkRequestModifierProtocol?
    func errorFactory(for type: MagellanRequestType) -> MagellanErrorNetworkFactoryProtocol?
}
