//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

class ClusterViewModel: NSObject, Coordinated {
    
    let cluster: Cluster
    
    var coordinates: Coordinates {
        return cluster.coordinates
    }
    
    var title: String {
        return String(cluster.quantity)
    }
    
    init(cluster: Cluster) {
        self.cluster = cluster
    }
    
}
