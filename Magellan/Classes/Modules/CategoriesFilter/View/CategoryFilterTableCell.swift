//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import UIKit

final class CategoryFilterTableCell: UITableViewCell {

    private struct Constants {
        static let topOffset: CGFloat = 10
        static let sideOffset: CGFloat = 16
        static let imageSize: CGSize = .init(width: 44, height: 44)
    }
    
    private var logoView: UIImageView
    private var categoryLabel: UILabel
    private var selectedView: UIImageView
    
    struct Style {
        let titleFont: UIFont
        let titleColor: UIColor
        let selectedImage: UIImage
        let logoBackground: UIColor
    }
    
    var style: Style? {
        didSet {
            applyStyle()
        }
    }

    var viewModel: CategoryFilterViewModel? {
        didSet {
            configureContent()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        logoView = UIImageView()
        categoryLabel = UILabel()
        selectedView = UIImageView()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectedView.isHidden = !selected
    }
    
    private func configureUI() {
        selectionStyle = .none
        logoView.contentMode = .center
        logoView.layer.cornerRadius = Constants.imageSize.width / 2
        logoView.layer.masksToBounds = true
        selectedView.contentMode = .scaleAspectFill
        
        contentView.addSubview(logoView)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(selectedView)
    }
    
    private func setupLayout() {
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.leftAnchor.constraint(equalTo: contentView.leftAnchor,
                                       constant: Constants.sideOffset).isActive = true
        logoView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                      constant: Constants.topOffset).isActive = true
        logoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                         constant: -Constants.topOffset).isActive = true
        logoView.widthAnchor.constraint(equalToConstant: Constants.imageSize.width).isActive = true
        logoView.heightAnchor.constraint(equalToConstant: Constants.imageSize.height).isActive = true
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        categoryLabel.leftAnchor.constraint(equalTo: logoView.rightAnchor,
                                            constant: Constants.sideOffset).isActive = true
        categoryLabel.rightAnchor.constraint(equalTo: selectedView.leftAnchor,
                                            constant: -Constants.sideOffset).isActive = true
        
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        selectedView.rightAnchor.constraint(equalTo: contentView.rightAnchor,
                                            constant: -Constants.sideOffset).isActive = true
        selectedView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    private func applyStyle() {
        guard let style = style else {
            return
        }
        categoryLabel.font = style.titleFont
        categoryLabel.textColor = style.titleColor
        selectedView.image = style.selectedImage
        logoView.backgroundColor = style.logoBackground
    }
    
    private func configureContent() {
        logoView.image = viewModel?.image
        categoryLabel.text = viewModel?.name
    }

}
