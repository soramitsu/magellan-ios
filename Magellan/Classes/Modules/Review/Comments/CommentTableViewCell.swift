//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import SoraUI

final class CommentTableViewCell: UITableViewCell {
    
    private let offset: CGFloat = 8
    
    lazy private var rootStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 12.0
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var verticalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8.0
        view.distribution = .fillEqually
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var horizontalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 16.0
        view.distribution = .fill
        view.alignment = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy private var avatarView: ImageWithTitleView = {
        let view = ImageWithTitleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var titleLabel: UILabel = {
        let view = UILabel()
        return view
    }()
    
    lazy private var ratingView: RatingView = {
        let image = UIImage(named: "rating", in: .frameworkBundle, compatibleWith: nil) ?? UIImage()
        let view = RatingView(image: image, itemSize: .init(width: 12.0, height: 11.5), spacing: 4)
        return view
    }()
    
    lazy private var messageLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
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
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(ratingView)

        horizontalStackView.addArrangedSubview(avatarView)
        horizontalStackView.addArrangedSubview(verticalStackView)
        
        rootStackView.addArrangedSubview(horizontalStackView)
        rootStackView.addArrangedSubview(messageLabel)
        
        contentView.addSubview(rootStackView)
        var constraints = [
            rootStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                constant: offset * 2),
            rootStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -offset * 2),
            rootStackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                constant: offset),
            rootStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                constant: -offset),
            avatarView.heightAnchor.constraint(equalToConstant: 44.0),
            avatarView.widthAnchor.constraint(equalToConstant: 44.0)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        avatarView.makeRound()
    }
}
extension CommentTableViewCell {
    
    func bind(viewModel: CommentViewModelProtocol) {
        titleLabel.text = viewModel.title
        ratingView.rating = viewModel.rate
        ratingView.comment = viewModel.creationDate
        messageLabel.text = viewModel.message
        avatarView.title = viewModel.shortTitle
    }
    
}
extension CommentTableViewCell {
    
    // MARK: CellStyles
    
    struct Default: ViewStyleProtocol {
        
        let style: MagellanStyleProtocol
        
        func apply(to view: UIView) {
            (view as? CommentTableViewCell).map {
                $0.selectionStyle = .none
                $0.titleLabel.textColor = style.textAfro
                $0.titleLabel.font = style.medium15
                $0.messageLabel.textColor = style.darkTextColor
                $0.messageLabel.font = style.regular14
                $0.avatarView.backgroundColor = style.iconsBack
                $0.avatarView.titleColor = style.descriptionTextColor
                $0.avatarView.titleFont = style.semiBold15
                $0.ratingView.tintColor = style.accent
                $0.ratingView.set(style: .init(disabledColor: style.dividerColor,
                                               ratingFont: style.semiBold14,
                                               ratingColor: style.textAfro,
                                               bodyFont: style.regular14,
                                               bodyColor: style.lighterGray,
                                               isRateValueHidden: true))
                
            }
        }
    }
}
