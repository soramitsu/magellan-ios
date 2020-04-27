/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation
import UIKit


final class MapDetailCell: UITableViewCell {
    
    private struct Constants {
        static let sideOffset: CGFloat = 16
        static let contentOffset: CGFloat = 20
    }
    
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()

    var viewModel: MapDetailViewModel? {
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

    
    private func configureViews() {
        titleLabel.font = .styleFont(for: .body)
        titleLabel.textColor = UIColor.Style.Text.announcement
        contentView.addSubview(titleLabel)
        
        contentLabel.font = .styleFont(for: .body)
        contentLabel.textAlignment = .right
        contentLabel.textColor = UIColor.Style.Text.mapDetail
        contentLabel.numberOfLines = 0
        contentView.addSubview(contentLabel)
    }
    
    private func layoutViews() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constants.sideOffset).isActive = true
        titleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 200).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Constants.sideOffset).isActive = true
        contentLabel.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 20).isActive = true
        contentLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    private func configureContent() {
        guard let viewModel = viewModel else {
            return
        }
        titleLabel.text = viewModel.title
        contentLabel.text = viewModel.content
    }
    
}
