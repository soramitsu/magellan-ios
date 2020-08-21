//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import UIKit
import SoraUI

protocol ModalDraggable {
    var view: UIView! { get }
    var draggableView: UIView { get }
    var compactHeight: CGFloat { get }
    var fullHeight: CGFloat { get }
    var isBeingDismissed: Bool { get }
    var isDraggableDismissEnabled: Bool { get }
    
    func dismiss()
    func viewWillChangeFrame(to frame: CGRect)
}

class ModalDraggablePresentationViewController: UIPresentationController {

    private struct Constants {
        static let doubleOffset: CGFloat = 16
        static let backButtonWidth: CGFloat = 40
        static let topOffset: CGFloat = 44
    }
    
    weak var underlyingView: UIView?
    private lazy var modalView: ModalView = {
        let view = ModalView(frame: UIScreen.main.bounds)
        view.blockedView = underlyingView
        view.addSubview(backButton)
        return view
    }()

    private lazy var backButton: RoundedButton = {
        let bounds = presentingViewController.view.bounds
        let yPosition = bounds.height - modalDraggable.compactHeight - Constants.backButtonWidth - Constants.doubleOffset * 2
        let button = RoundedButton(frame: CGRect(x: Constants.doubleOffset,
                                                 y: yPosition,
                                                 width: 40,
                                                 height: 40))
        button.imageWithTitleView?.iconImage = UIImage(named: "arrow-left", in: .frameworkBundle, compatibleWith: nil)
        button.roundedBackgroundView?.cornerRadius = 40 / 2
        button.roundedBackgroundView?.shadowOpacity = 0.36
        button.roundedBackgroundView?.shadowOffset = CGSize(width: 0, height: 2)
        button.roundedBackgroundView?.fillColor = .white
        button.roundedBackgroundView?.highlightedFillColor = .white
        button.changesContentOpacityWhenHighlighted = true
        button.addTarget(self, action: #selector(dismissHandler), for: .touchUpInside)
        return button
    }()
    
    var modalDraggable: ModalDraggable! {
        guard let result = presentedViewController as? ModalDraggable else {
            fatalError("presentedViewController should confom to ModalDraggable protocol")
        }
        return result
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
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        modalDraggable.draggableView.addGestureRecognizer(gesture)
    }
    
    private var startedHeight: CGFloat = 0
    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        let view = modalDraggable.view!
        
        switch gesture.state {
        case .began:
           startedHeight = gesture.translation(in: view).y
        case .changed:
           let newY = gesture.translation(in: view).y
           let delta = newY - startedHeight
           startedHeight = newY
           let newOrigin = CGPoint(x: view.frame.origin.x, y: view.frame.origin.y + delta)
           if view.bounds.height - newOrigin.y < modalDraggable.compactHeight - 20 {
                if !modalDraggable.isDraggableDismissEnabled {
                    return
                }
                dismissHandler()
                return
           }

           if view.bounds.height - newOrigin.y > modalDraggable.fullHeight {
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
        backButton.frame = backButtonFrame(with: frame)
        view.frame = frame

        UIView.commitAnimations()
   }

    private func backButtonFrame(with frame: CGRect) -> CGRect {
        let newYOrigin = frame.origin.y - Constants.backButtonWidth - Constants.doubleOffset * 2
        let minYOrigin = Constants.topOffset
        return CGRect(x: backButton.frame.origin.x,
                      y: max(newYOrigin, minYOrigin),
                      width: backButton.frame.size.width,
                      height: backButton.frame.size.height)
    }

    @objc
    private func dismissHandler() {
        modalDraggable.dismiss()
        modalView.removeFromSuperview()
    }
    
}
