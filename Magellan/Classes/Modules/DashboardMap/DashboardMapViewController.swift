//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import UIKit

final class DashboardMapViewController: ContainerViewController {
    
    let presenter: DashboardMapPresenterProtocol
    
    init(presenter: DashboardMapPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboards are incompatible with truth and beauty.")
    }
    
    func set(title: String) {
        self.title = title
    }
}

extension DashboardMapViewController: DashboardMapViewProtocol {}
