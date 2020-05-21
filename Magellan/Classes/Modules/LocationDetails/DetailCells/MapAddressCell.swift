/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation
import UIKit


final class MapAddressCell: UITableViewCell {
    
    private struct Constants {
        static let titleHeight: CGFloat = 16
        static let titleTopOffset: CGFloat = 17
        static let labelInset: CGFloat = 20
        static let descriptionTopOffset: CGFloat = 15
        static let descriptionBottomInset: CGFloat = 16
        static let offset: CGFloat = 10
    }
    
    static var baseHeight: CGFloat {
        return Constants.titleTopOffset
            + Constants.titleHeight
            + Constants.descriptionTopOffset
            + Constants.descriptionBottomInset
    }
    
    private let titleLabel = UILabel()
    private let addressLabel = UILabel()
    private let iconView = UIImageView()
    
    struct Style {
        let titleFont: UIFont
        let titleColor: UIColor
        let addressFont: UIFont
        let addressTextColor: UIColor
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
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        let selectedBackground = UIView()
        selectedBackground.backgroundColor = .white
        selectedBackgroundView = selectedBackground
        
        titleLabel.textColor = .black
        contentView.addSubview(titleLabel)
        
        addressLabel.numberOfLines = 0
        contentView.addSubview(addressLabel)
        
        iconView.contentMode = .scaleAspectFit
        contentView.addSubview(iconView)
    
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant:  Constants.labelInset).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant:  Constants.titleTopOffset).isActive = true
        
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        addressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant:  Constants.descriptionTopOffset).isActive = true
        addressLabel.rightAnchor.constraint(equalTo: iconView.leftAnchor, constant:  -Constants.offset).isActive = true
        addressLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant:  -Constants.descriptionBottomInset).isActive = true
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.topAnchor.constraint(equalTo: addressLabel.topAnchor).isActive = true
        iconView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Constants.labelInset).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: Constants.descriptionBottomInset).isActive = true
        iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyStyle() {
        guard let style = style else {
            return
        }
        titleLabel.font = style.titleFont
        titleLabel.textColor = style.titleColor
        addressLabel.font = style.addressFont
        addressLabel.textColor = style.addressTextColor
    }
    private func configureContent() {
        guard let viewModel = viewModel else {
            return
        }
        titleLabel.text = viewModel.title
        addressLabel.text = viewModel.content
        iconView.image = viewModel.image
    }
    
}
