/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation


//swiftlint:disable all
public enum L10n {

    static var sharedLanguage: MagellanLanguage = MagellanLanguage.defaultLanguage

    public enum MapListView {
        /// Nearby places
        public static var nearbyplaces: String { return localize("MapListView.nearbyplaces") }

        public enum Search {
            /// Search by name...
            public static var placeholder: String { return localize("MapListView.search.placeholder") }
        }
    }
}


extension L10n {

    fileprivate static func localize(_ key: String, _ args: CVarArg...) -> String {
        let format = getFormat(for: key, localization: sharedLanguage.rawValue)
        return String(format: format, arguments: args)
    }

    fileprivate static func getFormat(for key: String, localization: String) -> String {
        let bundle = Bundle(for: BundleLoadHelper.self)

        guard
            let path = bundle.path(forResource: localization, ofType: "lproj"),
            let langBundle = Bundle(path: path) else {
                return ""
        }

        return NSLocalizedString(key, tableName: nil, bundle: langBundle, value: "", comment: "")
    }

}


private final class BundleLoadHelper {}
//swiftlint:enable all