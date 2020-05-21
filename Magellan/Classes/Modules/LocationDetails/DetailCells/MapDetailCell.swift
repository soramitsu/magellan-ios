/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation
import UIKit


final class MapDetailCell: UITableViewCell {
    
    private struct Constants {
        static let sideOffset: CGFloat = 20
        static let offset: CGFloat = 7
    }
    
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
    private let iconView = UIImageView()
    
    struct Style {
        let titleFont: UIFont
        let titleTextColor: UIColor
        let contentFont: UIFont
        let contentTextColor: UIColor
    }
    
    var style: Style? {
        didSet {
            applyStyle()
        }
    }

    var viewModel: MapDetailViewModelProtocol? {
        didSet {
            configureContent()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let selectedBackground = UIView()
        selectedBackground.backgroundColor = .white
        selectedBackgroundView = selectedBackground
        backgroundColor = .clear
        contentView.backgroundColor = .white
        selectionStyle = .none
        
        configureViews()
        layoutViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func applyStyle() {
        guard let style = style else {
            return
        }
        titleLabel.font = style.titleFont
        titleLabel.textColor = style.titleTextColor
        contentLabel.font = style.contentFont
        contentLabel.textColor = style.contentTextColor
    }
    
    private func configureViews() {
        contentLabel.textAlignment = .right
        contentView.addSubview(titleLabel)
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .right
        contentView.addSubview(contentLabel)
        
        iconView.contentMode = .scaleAspectFit
        contentView.addSubview(iconView)
    }
    
    private func layoutViews() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constants.sideOffset).isActive = true
        titleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 200).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.rightAnchor.constraint(equalTo: iconView.leftAnchor, constant: -Constants.offset).isActive = true
        contentLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Constants.sideOffset).isActive = true
        iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    private func configureContent() {
        guard let viewModel = viewModel else {
            return
        }
        titleLabel.text = viewModel.title
        contentLabel.text = viewModel.content
        iconView.image = viewModel.image
    }
    
}
