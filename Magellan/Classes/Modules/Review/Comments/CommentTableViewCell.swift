//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import SoraUI

protocol CommentViewModelProtocol: BindableViewModelProtocol {
    var title: String { get }
    var rate: Double { get }
    var creationDate: String { get }
    var message: String { get }
    var avatarURL: String? { get }
}
extension CommentViewModelProtocol {
    
    var title: String { "Lula Shelton" }
    var rate: Double { 3.0 }
    var creationDate: String { "13 Jan 2019" }
    var message: String { "The best latte I’ve had in Phnom Penh, one of the best of any I’ve had elsewhere. Nice ambiance, good decor." }
    var avatarURL: String? { nil }
    
}

struct CommentViewModel<Cell: CommentTableViewCell>: CommentViewModelProtocol {
    
    let style: MagellanStyleProtocol
    let fullName: String
    let rate: Double
    let date: Date
    let text: String
    var avatarURL: String?
        
    var cellType: UITableViewCell.Type { Cell.self }
    
    func bind(to cell: UITableViewCell) {
        (cell as? Cell).map {
            $0.bind(viewModel: self)
            Cell.Default(style: style).apply(to: $0)
        }
    }
}

class CommentTableViewCell: UITableViewCell {
    
    private let offset: CGFloat = 8
    
    lazy private var contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 0.0
        view.distribution = .fillEqually
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
        view.distribution = .fillEqually
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy private var avatarView: UIImageView = {
        let view = UIImageView()
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
        view.translatesAutoresizingMaskIntoConstraints = false
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
        avatarView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        horizontalStackView.addArrangedSubview(verticalStackView)
        contentStackView.addArrangedSubview(horizontalStackView)
        
        contentView.addSubview(contentStackView)
        
        var constraints = [
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                constant: offset * 2),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -offset * 2),
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                constant: offset),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                constant: -offset),
        ]
        constraints.append(contentsOf: [
            avatarView.widthAnchor.constraint(equalToConstant: 44.0),
            avatarView.heightAnchor.constraint(equalToConstant: 44.0)
        ].map {
            $0.priority = .defaultHigh
            return $0
        })
        
        NSLayoutConstraint.activate(constraints)
        
//        contentView.addSubview(ratingView)
//        ratingView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            ratingView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            ratingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            ratingView.leftAnchor.constraint(equalTo: contentView.leftAnchor,
//                                             constant: 2 * offset)
//        ])
    }
}
extension CommentTableViewCell {
    
    func bind(viewModel: CommentViewModelProtocol) {
        titleLabel.text = viewModel.title
        ratingView.rating = viewModel.rate
        ratingView.comment = viewModel.creationDate
        messageLabel.text = viewModel.message
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
