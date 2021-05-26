//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

final class DemoPlaceProvider: PlaceProvider {

    let service: MagellanServicePrototcol
    var place: PlaceInfo?
    
    internal init(service: MagellanServicePrototcol) {
        self.service = service
    }
    
    func getPlaceInfo(completion: @escaping (PlaceInfo) -> Void) {
        service.getPlace(with: "1", runCompletionIn: .main) { result in
            switch result {
                case .success(let place):
                    completion(place)
                case.failure(_): break
            }
        }
    }
}
