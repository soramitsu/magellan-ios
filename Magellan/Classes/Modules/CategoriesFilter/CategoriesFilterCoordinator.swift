//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

final class CategoriesFilterCoordinator {
    weak var presenter: CategoriesFilterPresenterProtocol?
}

extension CategoriesFilterCoordinator: CategoriesFilterCoordinatorProtocol { }
