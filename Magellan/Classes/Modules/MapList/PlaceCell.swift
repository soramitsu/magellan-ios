//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation
import UIKit


final class PlaceCell: UITableViewCell {

    private struct Constants {
        static let offset: CGFloat = 8
        static let doubleOffset: CGFloat = 16
    }
    
    private let nameLabel = UILabel()
    private let categoryLabel = UILabel()
    
    var place: PlaceViewModel? {
        didSet {
            configureContent()
        }
    }
    
    final class Style {
        let nameFont: UIFont
        let nameColor: UIColor
        let categoryFont: UIFont
        let categoryTextColor: UIColor
        
        init(nameFont: UIFont,
             nameColor: UIColor,
             categoryFont: UIFont,
             categoryTextColor: UIColor) {
            self.nameFont = nameFont
            self.nameColor = nameColor
            self.categoryFont = categoryFont
            self.categoryTextColor = categoryTextColor
        }
    }
    
    var style: Style? {
        didSet {
            applyStyle()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        accessoryType = .none
        let selectedBackground = UIView()
        selectedBackground.backgroundColor = .clear
        selectedBackgroundView = selectedBackground
        
        configureViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(categoryLabel)
    }
    
    private func applyStyle() {
        guard let style = style else {
            return
        }
        nameLabel.font = style.nameFont
        nameLabel.textColor = style.nameColor
        categoryLabel.textColor = style.categoryTextColor
        categoryLabel.font = style.categoryFont
    }
    
    private func layoutViews() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                       constant: Constants.doubleOffset).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor,
                                        constant: Constants.doubleOffset).isActive = true
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                       constant: Constants.doubleOffset).isActive = true
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        categoryLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        categoryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,
                                           constant: Constants.offset).isActive = true
        categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                              constant: -Constants.doubleOffset).isActive = true
    }
    
    private func configureContent() {
        guard let place = place else {
            return
        }
        
        nameLabel.text = place.name
        categoryLabel.text = place.category
    }
    
}

