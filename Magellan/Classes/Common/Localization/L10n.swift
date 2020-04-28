/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation


//swiftlint:disable all
public enum L10n {

    static var sharedLanguage: MagellanLanguage = MagellanLanguage.defaultLanguage

    public enum Location {

        public enum Details {
            /// E-mail
            public static var email: String { return localize("Location.Details..email") }
            /// FB
            public static var fb: String { return localize("Location.Details..fb") }
            /// Address
            public static var address: String { return localize("Location.Details.address") }
            /// Phone number
            public static var phone: String { return localize("Location.Details.phone") }
            /// Website
            public static var website: String { return localize("Location.Details.website") }

            public enum Status {
                /// Closed
                public static var closed: String { return localize("Location.Details.Status.Closed") }
                /// Closed till %@
                public static func closedTill(_ p1: String) -> String {
                    return localize("Location.Details.Status.ClosedTill", p1)
                }
                /// Open
                public static var `open`: String { return localize("Location.Details.Status.Open") }
                /// Open till %@
                public static func openTill(_ p1: String) -> String {
                    return localize("Location.Details.Status.OpenTill", p1)
                }
                /// Working hours: %@
                public static func workingHours(_ p1: String) -> String {
                    return localize("Location.Details.Status.workingHours", p1)
                }
            }
        }
    }

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