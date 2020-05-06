//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import UIKit

public protocol ErrorViewFactoryProtocol {
    func errorView(with retryClosure: @escaping () -> Void) -> UIView
}
