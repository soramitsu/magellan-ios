//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

private let kDefaultsKeyName = "l10n_lang"


public enum MagellanLanguage: String, CaseIterable {
    case english = "en"
    case japan = "ja"
    case russian = "ru"
    case spanish = "es-CO"
    case khmer = "km"
    case bashkir = "ba-RU"
    case italian = "it"
}


public extension MagellanLanguage {
    
    static var defaultLanguage: MagellanLanguage {
        return .english
    }
}


private final class BundleLoadHelper {}
