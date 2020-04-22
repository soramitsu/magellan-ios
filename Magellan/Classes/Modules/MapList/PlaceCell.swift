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
    
    var place: Place? {
        didSet {
            configureContent()
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
//        todo: set title
//        nameLabel.decorateForTitle2()
        contentView.addSubview(nameLabel)
        
//        categoryLabel.textColor = UIColor.Style.Text.announcement
//        categoryLabel.font = .styleFont(for: .favoriteCard)
        contentView.addSubview(categoryLabel)
                
//        distanceLabel.textColor = UIColor.Style.Text.announcement
//        distanceLabel.font = .styleFont(for: .favoriteCard)
        distanceLabel.textAlignment = .right
        contentView.addSubview(distanceLabel)
    }
    
    private func layoutViews() {
        nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        
        categoryLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        categoryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        
        distanceLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        distanceLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func configureContent() {
        guard let place = place else {
            return
        }
        
        nameLabel.text = place.name
        categoryLabel.text = place.type
//        timeLabel.text = place.openStatus
//        timeLabel.textColor = place.open ? UIColor.Style.Text.mapOpened : UIColor.Style.Text.mapClosed
//
//        if place.distance != 0.0 {
//            distanceLabel.text = String(format: "%.2f km", place.distance)
//        }
    }
    
}

