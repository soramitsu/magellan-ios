/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation
import UIKit


final class MapAddressCell: UITableViewCell {
    
    private struct Constants {
        static let titleTopOffset: CGFloat = 8
        static let labelInset: CGFloat = 16
        static let descriptionTopOffset: CGFloat = 6
        static let descriptionBottomInset: CGFloat = 6
        static let titleHeight: CGFloat = 24
    }
    
    static var baseHeight: CGFloat {
        return Constants.titleTopOffset
            + Constants.titleHeight
            + Constants.descriptionTopOffset
            + Constants.descriptionBottomInset
    }
    
    private let titleLabel = UILabel()
    private let addressLabel = UILabel()
    
    struct Style {
        let titleFont: UIFont
        let addressFont: UIFont
        let addressTextColor: UIColor
    }
    
    var style: Style? {
        didSet {
            setStyle()
        }
    }
    
    var viewModel: MapAddressViewModel? {
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
    
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant:  -Constants.labelInset).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant:  Constants.labelInset).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant:  Constants.titleTopOffset).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: Constants.titleHeight).isActive = true
        
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant:  Constants.labelInset).isActive = true
        addressLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant:  -Constants.labelInset).isActive = true
        addressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant:  Constants.descriptionTopOffset).isActive = true
        addressLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant:  -Constants.descriptionBottomInset).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        guard let style = style else {
            return
        }
        titleLabel.font = style.titleFont
        addressLabel.font = style.addressFont
        addressLabel.textColor = style.addressTextColor
    }
    private func configureContent() {
        guard let viewModel = viewModel else {
            return
        }
        titleLabel.text = viewModel.title
        addressLabel.text = viewModel.description
    }
    
}
