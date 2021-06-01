//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

protocol CommentViewModelProtocol: BindableViewModelProtocol {
    var title: String { get }
    var shortTitle: String? { get }
    var rate: Double { get }
    var creationDate: String { get }
    var message: String { get }
    var avatarURL: String? { get }
    var isAllowedToExpand: Bool { get }
}
extension CommentViewModelProtocol {
    
    var title: String { "Lula Shelton" }
    var rate: Double { 3.0 }
    var creationDate: String { "13 Jan 2019" }
    var message: String { "The best latte I’ve had in Phnom Penh, one of the best of any I’ve had elsewhere. Nice ambiance, good decor." }
    var avatarURL: String? { nil }
    var shortTitle: String? { "LS" }
    
}
