//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import SoraUI

final class RateControlTableViewCell: UITableViewCell {
    
    lazy private var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "titleText"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 24.0
        view.distribution = .fillEqually
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var ratingView: RatingView = {
        let image = UIImage(named: "rating", in: .frameworkBundle, compatibleWith: nil) ?? UIImage()
        let view = RatingView(image: image,
                              itemSize: .init(width: 27.0, height: 27.0),
                              spacing: 26.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var shadowView: RoundedView = {
        let view = RoundedView()
        view.cornerRadius = 10.0
        view.shadowOpacity = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let offset: CGFloat = 8
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowView.applyPath()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutViews() {
        
        contentView.addSubview(shadowView)
        NSLayoutConstraint.activate([
            shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                constant: offset * 2),
            shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -offset * 2),
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                constant: offset * 2),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                constant: -offset * 2),
            shadowView.heightAnchor.constraint(equalToConstant: 117)
        ])
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(ratingView)

        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}

extension RateControlTableViewCell {
    
    func bind(viewModel: ControlCellViewModelProtocol) {
        titleLabel.text = viewModel.title
    }
    
}


extension RateControlTableViewCell {
    
    // MARK: CellStyles
    
    struct Default: ViewStyleProtocol {
        
        let style: MagellanStyleProtocol
        
        func apply(to view: UIView) {
            (view as? RateControlTableViewCell).map {
                $0.selectionStyle = .none
                $0.shadowView.fillColor = style.superLightGrayColor
                $0.ratingView.set(style: .init(disabledColor: style.dividerColor,
                                               ratingFont: style.semiBold14,
                                               ratingColor: style.textAfro,
                                               bodyFont: style.regular14,
                                               bodyColor: style.lighterGray))
                $0.ratingView.set(.disabled)
                $0.titleLabel.font = style.regular14
                $0.titleLabel.textColor = style.headerColor
            }
        }
    }
}

