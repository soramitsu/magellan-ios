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
    private let strategy: RoundedStrategy
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
    
    init(image: UIImage, strategy: RoundedStrategy = .base) {
        self.style = Style(disabledColor: .lightGray,
                           ratingFont: .systemFont(ofSize: 14),
                           ratingColor: .black,
                           bodyFont: .systemFont(ofSize: 14),
                           bodyColor: .gray)
        self.image = image
        self.strategy = strategy
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
        let roundedRating = strategy.apply(to: rating)
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

extension RatingView {
    
    /// Provides rules for converting Double rating value to required visual format
    enum RoundedStrategy: Int {
        
        case base // legacy
        case review // Ex: 4.9 score into 3 for 0...4 visual collection
        
        func apply(to value: Double) -> Int {
            
            switch self {
            case .base:
                return Int(value)
            case .review:
                return Int(value.rounded(.down)) - 1
            }
            
        }

    }
    
    enum State {
        
        case disabled
        case normal
        
        func apply(to view: RatingView) {
            
            switch self {
            case .disabled:
                view.commentLabel.isHidden = true
                view.ratingLabel.isHidden = true
            case .normal:
                view.commentLabel.isHidden = false
                view.ratingLabel.isHidden = false
            }
        
        }
    }
    
    convenience init(image: UIImage, itemSize: CGSize, spacing: CGFloat) {
        self.init(image: image, strategy: .review)
        mainStack.spacing = spacing
        layoutViews(itemSize: itemSize)
    }
    
    private func layoutViews(itemSize: CGSize) {
        mainStack.arrangedSubviews.compactMap { $0 as? UIImageView }.forEach {
            $0.heightAnchor.constraint(equalToConstant: itemSize.height).isActive = true
            $0.widthAnchor.constraint(equalToConstant: itemSize.height).isActive = true
        }
    }
    
    func set(_ state: State) {
        state.apply(to: self)
    }
    
}
