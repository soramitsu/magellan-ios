/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation
import UIKit


protocol NavigationBarHiding: class {
    
    func needsToHide() -> Bool
    
}


extension NavigationBarHiding {
    
    func needsToHide() -> Bool {
        return true
    }
    
}


class BarHidingNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    
    @discardableResult
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        defer {
            if let topController = self.topViewController {
                handleDesignableNavigationIfNeeded(viewController: topController)
            }
        }
        
        return super.popToRootViewController(animated: animated)
    }
    
    private func setup() {
        delegate = self
        
        view.backgroundColor = .white
    }
    
    
    // MARK: UINavigationControllerDelegate
    
    public func navigationController(_ navigationController: UINavigationController,
                                     willShow viewController: UIViewController, animated: Bool) {
        handleDesignableNavigationIfNeeded(viewController: viewController)
    }
    
    
    // MARK: Private
    
    private func handleDesignableNavigationIfNeeded(viewController: UIViewController) {
        updateNavigationBarState(in: viewController)
        setupBackButtonItem(for: viewController)
    }
    
    private func updateNavigationBarState(in viewController: UIViewController) {
        guard let controller = viewController as? NavigationBarHiding else {
            setNavigationBarHidden(false, animated: true)
            return
        }
        
        setNavigationBarHidden(controller.needsToHide(), animated: true)
    }
    
    private func setupBackButtonItem(for viewController: UIViewController) {
        let backButtonItem = viewController.navigationItem.backBarButtonItem ?? UIBarButtonItem()
        backButtonItem.title = " "
        viewController.navigationItem.backBarButtonItem = backButtonItem
    }
}

