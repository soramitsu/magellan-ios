//
/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: GPL-3.0
 */


import UIKit

class ReviewTableViewCell: UITableViewCell {}

import SoraUI

class RateControlTableViewCell: UITableViewCell {
    
    lazy private var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "titleText"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
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
                                                constant: -offset * 2)
        ])
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(ratingView)

        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                constant: offset * 2),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -offset * 2),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                constant: offset * 2),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                constant: -offset * 2),
            stackView.heightAnchor.constraint(equalToConstant: 117)
        ])
    }
}

extension RateControlTableViewCell {
    
    func bind(viewModel: ControlCellViewModelProtocol) {
        
    }
    
    func apply(style: ViewStylable) {
        style.apply(to: self)
    }
}


extension RateControlTableViewCell {
    
    // MARK: CellStyles
    
    struct Default: ViewStylable {
        
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
            }
        }
    }
}

protocol RateTableViewCellStyleProtocol {
    
    func apply(to view: RateTableViewCell)
}

class RateTableViewCell: UITableViewCell {
    
    private let offset: CGFloat = 8
    
    lazy private var ratingView: RatingView = {
        let image = UIImage(named: "rating", in: .frameworkBundle, compatibleWith: nil) ?? UIImage()
        let view = RatingView(image: image)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutViews()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutViews() {
        contentView.addSubview(ratingView)
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ratingView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                            constant: 2 * offset),
            ratingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                               constant: -offset),
            ratingView.leftAnchor.constraint(equalTo: contentView.leftAnchor,
                                             constant: 2 * offset)
        ])
    }
    
    private func configureViews() {
        
    }
}

extension RateTableViewCell {
    
    func bind(viewModel: RateViewModelProtocol) {
        ratingView.rating = viewModel.rate 
        ratingView.comment = viewModel.comment
    }
    
    func apply(style: ViewStylable) {
        style.apply(to: self)
    }
}

extension RateTableViewCell {
    
    // MARK: CellStyles
    
    struct Default: ViewStylable {
        
        let style: MagellanStyleProtocol
        
        func apply(to view: UIView) {
            (view as? RateTableViewCell).map {
                $0.selectionStyle = .none
                $0.ratingView.set(style: .init(disabledColor: style.dividerColor,
                                               ratingFont: style.semiBold14,
                                               ratingColor: style.textAfro,
                                               bodyFont: style.regular14,
                                               bodyColor: style.lighterGray))
            }
        }
    }
}

protocol ViewStylable {
    
    func apply(to view: UIView)
}

