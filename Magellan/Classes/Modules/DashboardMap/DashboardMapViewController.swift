//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import UIKit

final class DashboardMapViewController: ContainerViewController {

    var appearsClosure: Closure?
    var disappearsClosure: Closure?
    
    let presenter: DashboardMapPresenterProtocol
    
    init(presenter: DashboardMapPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboards are incompatible with truth and beauty.")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appearsClosure?()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appearsClosure?()
    }
    
    func set(title: String) {
        self.title = title
    }
}

extension DashboardMapViewController: DashboardMapViewProtocol {}
