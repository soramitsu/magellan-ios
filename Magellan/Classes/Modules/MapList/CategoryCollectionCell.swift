//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation
import UIKit


final class CategoryCollectionCell: UICollectionViewCell {
    
    private let iconView = UIImageView()
    private let nameLabel = UILabel()
    var category: Category? {
        didSet {
            configureContent()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        configureViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        iconView.contentMode = .scaleAspectFit
        contentView.addSubview(iconView)
        
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.textColor = .black
        //TODO: set font
//        nameLabel.font = .styleFont(for: .favoriteCard)
        contentView.addSubview(nameLabel)
    }
    
    private func layoutViews() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        iconView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 38).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 8).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
    
    private func configureContent() {
        guard let category = category else {
            return
        }
        
        nameLabel.text = category.name
//        iconView.image = category.icon
    }
    
}

