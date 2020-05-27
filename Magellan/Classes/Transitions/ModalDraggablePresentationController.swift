//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import UIKit

protocol ModalDraggable {
    var view: UIView! { get }
    var draggableView: UIView { get }
    var compactHeight: CGFloat { get }
    var fullHeight: CGFloat { get }
    var isBeingDismissed: Bool { get }
    
    func dismiss()
    func viewWillChangeFrame(to frame: CGRect)
}

class ModalDraggablePresentationViewController: UIPresentationController {
    
    weak var underlyingView: UIView?
    private lazy var modalView: ModalView = {
        let view = ModalView(frame: UIScreen.main.bounds)
        view.blockedView = underlyingView
        return view
    }()
    
    var modalDraggable: ModalDraggable? {
        presentedViewController as? ModalDraggable
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let bounds = presentingViewController.view.bounds
        
        if let modalDraggable = modalDraggable {
            return CGRect(x: 0,
                          y: bounds.height - modalDraggable.compactHeight,
                          width: bounds.size.width,
                          height: bounds.size.height)
        }
        return CGRect(x: 0,
                      y: bounds.size.height / 2,
                      width: bounds.size.width,
                      height: bounds.size.height)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        containerView?.addSubview(modalView)
        containerView?.addSubview(presentedView!)
        if let modalDraggable = modalDraggable {
            let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
            modalDraggable.draggableView.addGestureRecognizer(gesture)
        }
    }
    
    private var startedHeight: CGFloat = 0
    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        guard let modalDraggable = modalDraggable,
            let view = modalDraggable.view else {
            return
        }
        
        switch gesture.state {
        case .began:
           startedHeight = gesture.translation(in: view).y
        case .changed:
           let newY = gesture.translation(in: view).y
           let delta = newY - startedHeight
           startedHeight = newY
           let newOrigin = CGPoint(x: view.frame.origin.x, y: view.frame.origin.y + delta)
           if view.bounds.height - newOrigin.y < modalDraggable.compactHeight - 20 {
                modalDraggable.dismiss()
                modalView.removeFromSuperview()
                return
           }
           let targetFrame = CGRect(x: 0,
                                    y: view.frame.origin.y + delta,
                                    width: view.bounds.width,
                                    height: view.bounds.height)
           animate(view: view, frame: targetFrame)
        case .cancelled, .ended:
            if modalDraggable.isBeingDismissed {
                return
            }
            let futureHeight = view.frame.height - view.frame.origin.y - gesture.velocity(in: view).y
            let height = (futureHeight - modalDraggable.compactHeight <= modalDraggable.fullHeight - futureHeight)
                ? modalDraggable.compactHeight
                : modalDraggable.fullHeight
            let newOrigin = view.frame.height - height
            let frame = CGRect(x: 0, y: newOrigin, width: view.bounds.width, height: view.bounds.height)
            animate(view: view, frame: frame)
        default:
            break
        }
    }
       
    private func animate(view: UIView, frame: CGRect) {
        modalDraggable?.viewWillChangeFrame(to: frame)
        UIView.beginAnimations(nil, context: nil)
        view.frame = frame
        UIView.commitAnimations()
   }
    
}
