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
        
        service.getPlaceSummaryInfo(with: "1", runCompletionIn: .main) {
            switch $0 {
            case .success(let placeInfo):
                completion(placeInfo)
            case .failure(_): break
            }
        }
        
    }
}
