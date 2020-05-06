//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import UIKit
import Magellan

final class MagellanErrorView: UIView {
    
    private var retryClosure: () -> Void
    private var button = UIButton(frame: .zero)
    private var label = UILabel()
    
    init(retryClosure: @escaping () -> Void) {
        self.retryClosure = retryClosure
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        label.numberOfLines = 0
        label.text = "An error occured, please try again"
        label.textAlignment = .center
        
        button.setTitle("Retry", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(buttonTapHandler(sender:)), for: .touchUpInside)
        
        addSubview(label)
        addSubview(button)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8).isActive = true
        button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8).isActive = true
    }
    
    @objc
    private func buttonTapHandler(sender: UIButton) {
        retryClosure()
    }
}


class MagellanErrorViewFactory: ErrorViewFactoryProtocol {
    
    func errorView(with retryClosure: @escaping () -> Void) -> UIView {
        return MagellanErrorView(retryClosure: retryClosure)
    }
    
    
}
