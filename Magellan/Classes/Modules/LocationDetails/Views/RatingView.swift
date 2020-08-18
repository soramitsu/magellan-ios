//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import UIKit

final class RatingView: UIView {

    private struct Constants {
        static let offset: CGFloat = 4
    }

    struct Style {
        let disabledColor: UIColor
        let ratingFont: UIFont
        let ratingColor: UIColor
        let bodyFont: UIFont
        let bodyColor: UIColor
    }

    private let image: UIImage
    private var mainStack: UIStackView!
    private var ratingLabel: UILabel!
    private var commentLabel: UILabel!

    private var style: Style
    var rating: Double = 0 {
        didSet {
            applyRating()
        }
    }

    var comment: String? {
        didSet {
            commentLabel.text = comment
        }
    }

    init(image: UIImage) {
        self.style = Style(disabledColor: .lightGray,
                           ratingFont: .systemFont(ofSize: 14),
                           ratingColor: .black,
                           bodyFont: .systemFont(ofSize: 14),
                           bodyColor: .gray)
        self.image = image
        super.init(frame: .zero)
        configureUI()
        setupConstraints()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        mainStack = UIStackView()
        mainStack.axis = .horizontal
        mainStack.distribution = .fill
        mainStack.spacing = 4

        for i in 0...4 {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = style.disabledColor
            mainStack.addArrangedSubview(imageView)
        }

        ratingLabel = UILabel()
        mainStack.addArrangedSubview(ratingLabel)

        commentLabel = UILabel()
        mainStack.addArrangedSubview(commentLabel)

        addSubview(mainStack)
    }

    private func setupConstraints() {
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mainStack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        mainStack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        mainStack.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    }

    func set(style: Style) {
        self.style = style
        applyRating()
        applyStyle()
    }

    private func applyStyle() {
        ratingLabel.font = style.ratingFont
        ratingLabel.textColor = style.ratingColor

        commentLabel.font = style.bodyFont
        commentLabel.textColor = style.bodyColor
    }

    private func applyRating() {
        let roundedRating = Int(rating)
        for i in 0...4 {
            let color = rating == 0 || i > roundedRating
                ? style.disabledColor
                : tintColor!
            mainStack.arrangedSubviews[i].tintColor = color
        }

        ratingLabel.text = String(format: "%.1f", rating)
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        applyRating()
    }

}
