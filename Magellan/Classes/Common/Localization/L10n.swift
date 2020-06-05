/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation


//swiftlint:disable all
public enum L10n {

    static var sharedLanguage: MagellanLanguage = MagellanLanguage.defaultLanguage
    /// Cancel
    public static var cancel: String { return localize("Cancel") }
    /// Retry
    public static var retry: String { return localize("Retry") }

    public enum Error {

        public enum Default {
            /// An error occured, please try again
            public static var message: String { return localize("Error.Default.Message") }
            /// Ooops
            public static var title: String { return localize("Error.Default.Title") }
        }
    }

    public enum Filter {
        /// Reset
        public static var reset: String { return localize("Filter.Reset") }
        /// Filter
        public static var title: String { return localize("Filter.title") }
    }

    public enum Location {

        public enum Details {
            /// Address
            public static var address: String { return localize("Location.Details.address") }
            /// E-mail
            public static var email: String { return localize("Location.Details.email") }
            /// FB
            public static var fb: String { return localize("Location.Details.fb") }
            /// Information
            public static var information: String { return localize("Location.Details.Information") }
            /// Phone number
            public static var phone: String { return localize("Location.Details.phone") }
            /// Website
            public static var website: String { return localize("Location.Details.website") }
            /// Working hours
            public static var workingHours: String { return localize("Location.Details.workingHours") }

            public enum Status {
                /// Closed
                public static var closed: String { return localize("Location.Details.Status.Closed") }
                /// Closed till
                public static var closedTill: String { return localize("Location.Details.Status.ClosedTill") }
                /// Open
                public static var `open`: String { return localize("Location.Details.Status.Open") }
                /// Open till
                public static var openTill: String { return localize("Location.Details.Status.OpenTill") }
            }
        }
    }

    public enum MainViewController {
        /// Places
        public static var title: String { return localize("MainViewController.title") }
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

        return NSLocalizedString(key, tableName: nil, bundle: Bundle.frameworkBundle, value: "", comment: "")
    }

}


private final class BundleLoadHelper {}
//swiftlint:enable all