//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import UIKit

final class CategoryFilterTableCell: UITableViewCell {
    
    private var logoView: UIImageView
    private var categoryLabel: UILabel
    private var countLabel: UILabel
    private var selectedView: UIImageView
    
    struct Style {
        let titleFont: UIFont
        let titleColor: UIColor
        let countFont: UIFont
        let countColor: UIColor
        let selectedImage: UIImage
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
        countLabel = UILabel()
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
        logoView.contentMode = .scaleAspectFill
        selectedView.contentMode = .scaleAspectFill
        
        contentView.addSubview(logoView)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(selectedView)
    }
    
    private func setupLayout() {
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        logoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7).isActive = true
        logoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7).isActive = true
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        categoryLabel.leftAnchor.constraint(equalTo: logoView.rightAnchor, constant: 15).isActive = true
        
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        countLabel.leftAnchor.constraint(equalTo: categoryLabel.rightAnchor, constant: 5).isActive = true
        
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        selectedView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        selectedView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        selectedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15).isActive = true
    }
    
    private func applyStyle() {
        guard let style = style else {
            return
        }
        categoryLabel.font = style.titleFont
        categoryLabel.textColor = style.titleColor
        countLabel.font = style.countFont
        countLabel.textColor = style.countColor
        selectedView.image = style.selectedImage
    }
    
    private func configureContent() {
        logoView.image = viewModel?.image
        categoryLabel.text = viewModel?.name
        countLabel.text = viewModel?.count
    }

}
