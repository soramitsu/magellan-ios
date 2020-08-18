//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import UIKit

final class LocationHeaderCell: UITableViewCell {

    private struct Constants {
        static let offset: CGFloat = 8
    }

    struct Style: StyleProtocol {
        let titleFont: UIFont
        let commentFont: UIFont
        let bodyFont: UIFont
        let reviewRatingFont: UIFont
        let darkColor: UIColor
        let tintColor: UIColor
        let bodyColor: UIColor
        let ratingDisabledColor: UIColor
    }

    private var mainStack: UIStackView!
    private var titleLabel: UILabel!
    private var commentLabel: UILabel!
    private var ratingView: RatingView!
    private var statusLabel: UILabel!
    private var statusCommentLabel: UILabel!
    private var statusStack: UIStackView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    private func configureUI() {
        mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.distribution = .equalSpacing
        mainStack.spacing = Constants.offset

        titleLabel = UILabel()
        mainStack.addArrangedSubview(titleLabel)

        commentLabel = UILabel()
        commentLabel.numberOfLines = 0
        mainStack.addArrangedSubview(commentLabel)

        statusStack = UIStackView()
        statusStack.axis = .horizontal
        statusStack.alignment = .trailing
        statusStack.spacing = 4

        statusLabel = UILabel()
        statusLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        statusStack.addArrangedSubview(statusLabel)

        statusCommentLabel = UILabel()
        statusStack.addArrangedSubview(statusCommentLabel)

        mainStack.addArrangedSubview(statusStack)

        ratingView = RatingView(image: UIImage(named: "rating",
                                               in: .frameworkBundle,
                                               compatibleWith: nil)!)
        mainStack.addArrangedSubview(ratingView)

        contentView.addSubview(mainStack)
        setupConstraints()
    }

    private func setupConstraints(offset: CGFloat = Constants.offset) {
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.topAnchor.constraint(equalTo: contentView.topAnchor,
                                       constant: 2 * offset).isActive = true
        mainStack.rightAnchor.constraint(equalTo: contentView.rightAnchor,
                                         constant: -2 * offset).isActive = true
        mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                          constant: -offset).isActive = true
        mainStack.leftAnchor.constraint(equalTo: contentView.leftAnchor,
                                        constant: 2 * offset).isActive = true
    }

    func bind(viewModel: LocationHeaderViewModel) {
        titleLabel.text = viewModel.title
        commentLabel.text = viewModel.comment
        updateRating(viewModel: viewModel)
        updateStatus(viewModel.status, comment: viewModel.subStatus)
    }

    private func updateRating(viewModel: LocationHeaderViewModel) {
        guard let rating = viewModel.rating else {
            ratingView.removeFromSuperview()
            return
        }
        // todo: implement logic
    }

    private func updateStatus(_ status: String?, comment: String?) {
        if status == nil && comment == nil {
            statusStack.removeFromSuperview()
            return
        }

        statusLabel.text = status
        statusCommentLabel.text = comment

        if statusStack.superview == nil {
            mainStack.addArrangedSubview(statusStack)
        }
    }

    func apply(style: Style) {
        titleLabel.font = style.titleFont
        titleLabel.textColor = style.darkColor

        commentLabel.font = style.commentFont
        commentLabel.textColor = style.bodyColor

        ratingView.set(style: .init(disabledColor: style.ratingDisabledColor,
                                    ratingFont: style.reviewRatingFont,
                                    ratingColor: style.darkColor,
                                    bodyFont: style.bodyFont,
                                    bodyColor: style.bodyColor))
        ratingView.tintColor = style.tintColor

        statusLabel.font = style.bodyFont
        statusLabel.textColor = style.tintColor

        statusCommentLabel.font = style.bodyFont
        statusCommentLabel.textColor = style.bodyColor
    }
    
}

extension LocationHeaderCell: Bindable, StyleApplicable {
    func bind(viewModel: ViewModelProtocol) {
        guard let viewModel = viewModel as? LocationHeaderViewModel else {
            return
        }
        bind(viewModel: viewModel)
    }

    func allpy(style: StyleProtocol) {
        guard let style = style as? Style else {
            return
        }
        apply(style: style)
    }


}
