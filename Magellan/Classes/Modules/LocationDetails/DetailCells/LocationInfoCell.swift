//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import UIKit

final class LocationInfoCell: UITableViewCell {

    private struct Constants {
        static let offset: CGFloat = 8
    }

    struct Style: StyleProtocol {
        let font: UIFont
        let textColor: UIColor
        let separatorColor: UIColor
    }
    private(set) var viewModel: MapDetailViewModel?
    private var iconView: UIImageView!
    private var titleLabel: UILabel!
    private var separator: UIView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        addSubview(iconView)

        titleLabel = UILabel()
        addSubview(titleLabel)

        separator = UIView()
        addSubview(separator)
    }

    private func setupConstraints() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor, multiplier: 1).isActive = true
        iconView.topAnchor.constraint(equalTo: topAnchor,
                                      constant: Constants.offset * 2).isActive = true
        iconView.leftAnchor.constraint(equalTo: leftAnchor,
                                      constant: Constants.offset * 2).isActive = true
        iconView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                         constant: -Constants.offset * 2).isActive = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: iconView.rightAnchor,
                                         constant: Constants.offset * 2).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor,
                                         constant: -Constants.offset * 2).isActive = true

        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        separator.rightAnchor.constraint(equalTo: titleLabel.rightAnchor).isActive = true
        separator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
}

extension LocationInfoCell: Bindable, StyleApplicable {
    func bind(viewModel: ViewModelProtocol) {
        self.viewModel = viewModel as? MapDetailViewModel
        iconView.image = self.viewModel?.image
        titleLabel.text = self.viewModel?.content
        switch self.viewModel?.type {
        case .workingHours:
            titleLabel.numberOfLines = 0
        default:
            titleLabel.numberOfLines = 1
        }
    }

    func allpy(style: StyleProtocol) {
        guard let style = style as? Style else {
            return
        }
        titleLabel.font = style.font
        titleLabel.textColor = style.textColor
        separator.backgroundColor = style.separatorColor
    }
}
