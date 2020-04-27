//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation
import UIKit


final class PlaceCell: UITableViewCell {
    
    private let nameLabel = UILabel()
    private let categoryLabel = UILabel()
    private let timeLabel = UILabel()
    private let distanceLabel = UILabel()
    
    var place: PlaceViewModel? {
        didSet {
            configureContent()
        }
    }
    
    final class Style {
        let nameFont: UIFont
        let categoryFont: UIFont
        let categoryTextColor: UIColor
        let distanceFont: UIFont
        let distanceColor: UIColor
        
        init(nameFont: UIFont,
             categoryFont: UIFont,
             categoryTextColor: UIColor,
             distanceFont: UIFont,
             distanceColor: UIColor) {
            self.nameFont = nameFont
            self.categoryFont = categoryFont
            self.categoryTextColor = categoryTextColor
            self.distanceFont = distanceFont
            self.distanceColor = distanceColor
        }
    }
    
    var style: Style? {
        didSet {
            setStyle()
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
        nameLabel.textColor = .black
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        contentView.addSubview(nameLabel)
        
        contentView.addSubview(categoryLabel)
                
        distanceLabel.textAlignment = .right
        contentView.addSubview(distanceLabel)
    }
    
    private func setStyle() {
        guard let style = style else {
            return
        }
        nameLabel.font = style.nameFont
        categoryLabel.textColor = style.categoryTextColor
        categoryLabel.font = style.categoryFont
        distanceLabel.textColor = style.distanceColor
        distanceLabel.font = style.distanceFont
    }
    
    private func layoutViews() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        categoryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        distanceLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func configureContent() {
        guard let place = place else {
            return
        }
        
        nameLabel.text = place.name
        categoryLabel.text = place.category

        
        if place.distance != 0.0 {
            distanceLabel.text = String(format: "%.2f km", place.distance)
        }
    }
    
}

