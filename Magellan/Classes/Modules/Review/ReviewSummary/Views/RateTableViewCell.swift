//
/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: GPL-3.0
 */


import UIKit

final class RateTableViewCell: UITableViewCell {
    
    private let offset: CGFloat = 8
    
    lazy private var ratingView: RatingView = {
        let image = UIImage(named: "rating", in: .frameworkBundle, compatibleWith: nil) ?? UIImage()
        let view = RatingView(image: image, itemSize: .init(width: 16.0, height: 16.0), spacing: 8)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutViews() {
        contentView.addSubview(ratingView)
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        
        let margins = contentView.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            ratingView.topAnchor.constraint(equalTo: margins.topAnchor),
            ratingView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            ratingView.leftAnchor.constraint(equalTo: margins.leftAnchor)
        ])
    }
    
}

extension RateTableViewCell {
    
    func bind(viewModel: RateViewModelProtocol) {
        ratingView.rating = viewModel.rate
        ratingView.comment = viewModel.comment
        contentView.layoutMargins = viewModel.margins
    }
    
}

extension RateTableViewCell {
    
    // MARK: CellStyles
    
    struct Default: ViewStyleProtocol {
        
        let style: MagellanStyleProtocol
        
        func apply(to view: UIView) {
            (view as? RateTableViewCell).map {
                $0.selectionStyle = .none
                $0.ratingView.tintColor = style.accent
                $0.ratingView.set(style: .init(disabledColor: style.dividerColor,
                                               ratingFont: style.semiBold14,
                                               ratingColor: style.textAfro,
                                               bodyFont: style.regular14,
                                               bodyColor: style.lighterGray))
            }
        }
    }
}

protocol ViewStyleProtocol {
    
    func apply(to view: UIView)
}

