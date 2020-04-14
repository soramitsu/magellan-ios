//
//  EmptyViewController.swift
//  MagellanExample
//
//  Created by Iskander Foatov on 14.04.2020.
//  Copyright © 2020 Iskander Foatov. All rights reserved.
//

import UIKit

class EmptyViewController: UIViewController {

    weak var delegate: ModuleDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let button = UIButton(type: .custom)
        button.setTitle("close", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(nil, action: #selector(close), for: .touchUpInside)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc
    private func close() {
        delegate?.moduleDidFinish()
    }

}
