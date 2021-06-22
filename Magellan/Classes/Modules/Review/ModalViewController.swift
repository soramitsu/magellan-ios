//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import UIKit

class ModalViewController: UIViewController {
    
    weak var rootViewController: UIViewController?
    
    init(rootViewController: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        self.addRoot(rootViewController)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboards are incompatible with truth and beauty.")
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        configureViews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func addRoot(_ rootViewController: UIViewController) {
        addChild(rootViewController)
        view.addSubview(rootViewController.view)
        rootViewController.didMove(toParent: self)
        self.rootViewController = rootViewController
    }

    private func configureViews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(dismissController))
    }
    
    @objc func dismissController() {
        dismiss(animated: true, completion: nil)
    }
}
