//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import UIKit

class ReviewTableViewCell: UITableViewCell {}

class RateControlTableViewCell: UITableViewCell {}

protocol ConfigurableCell: UITableViewCell {}

protocol RateTableViewCellStyleProtocol {
    
    var style: MagellanStyleProtocol { get }
    
    func apply(to view: RateTableViewCell)
}

class RateTableViewCell: UITableViewCell, ConfigurableCell {
        
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
        selectionStyle = .none
    }
}

extension RateTableViewCell {
        
    func bind(viewModel: RateViewModelProtocol) {
        let viewModel = viewModel as? RateViewModelProtocol
        ratingView.rating = viewModel?.rate ?? .zero
        ratingView.comment = viewModel?.comment
    }

    func apply(style: RateTableViewCellStyleProtocol) {
        style.apply(to: self)
    }
}

extension RateTableViewCell {
    
    struct Style: RateTableViewCellStyleProtocol {

        let style: MagellanStyleProtocol
        
        func apply(to view: RateTableViewCell) {
            view.ratingView.set(style: .init(disabledColor: style.dividerColor,
                                        ratingFont: style.semiBold14,
                                        ratingColor: style.primaryColor,
                                        bodyFont: style.regular14,
                                        bodyColor: style.grayColor))
        }
    }
}
