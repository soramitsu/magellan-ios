/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation
import UIKit


final class DraggableNavigationController: BarHidingNavigationController {
    
    weak var draggableDelegate: DraggableDelegate?
    private var draggableState: DraggableState = .compact
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
    }
    
}


extension DraggableNavigationController: Draggable {
    
    var draggableView: UIView {
        return view
    }
        
    var scrollPanRecognizer: UIPanGestureRecognizer? {
        return nil
    }
    
    func set(dragableState: DraggableState, animated: Bool) {
        self.draggableState = dragableState
        
        if draggableState == .compact {
            view.endEditing(true)
        }
    }
    
    func set(contentInsets: UIEdgeInsets, for state: DraggableState) {
    }
    
    func canDrag(from state: DraggableState) -> Bool {
        return true
    }
    
    func animate(progress: Double, from oldState: DraggableState, to newState: DraggableState, finalFrame: CGRect) {
        UIView.beginAnimations(nil, context: nil)

        draggableView.frame = finalFrame

        UIView.commitAnimations()
    }
    
}

