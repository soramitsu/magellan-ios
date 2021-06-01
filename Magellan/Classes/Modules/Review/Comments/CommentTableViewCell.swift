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
    
    lazy private var messageLabel: ExpandingLabel = {
        let view = ExpandingLabel()
        view.numberOfLines = 5
        view.contentMode = .top
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        roundAvatarView()
        messageLabel.shouldTruncate()
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
    
    private func roundAvatarView() {
        guard avatarView.layer.mask == nil else { return }
        avatarView.makeRound()
    }
    
}
extension CommentTableViewCell {
    
    var expandingView: ExpandingLabel { messageLabel }
    
    func bind(viewModel: CommentViewModelProtocol) {
        titleLabel.text = viewModel.title
        ratingView.rating = viewModel.rate
        ratingView.comment = viewModel.creationDate
        avatarView.title = viewModel.shortTitle
        messageLabel.text = viewModel.message
    }
    
}
extension CommentTableViewCell {
    
    // MARK: CellStyles
    
    struct Default: ViewStyleProtocol {
        
        let style: MagellanStyleProtocol
        
        func apply(to view: UIView) {
            (view as? CommentTableViewCell).map {
                $0.messageLabel.style = .init(color: style.darkTextColor,
                                              font: style.semiBold14)
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

extension CommentTableViewCell {
    
    final class ExpandingLabel: UILabel {
        
        struct ReadMoreStyle {
            var tail: String = "... "
            var more: String = "More"
            var maxOffset: Int = 40
            var color: UIColor = .black
            var font: UIFont = UIFont.systemFont(ofSize: 14)
        }
        var style: ReadMoreStyle = ReadMoreStyle()

        private var canExpand: Bool = false
        private var maxNumberOfLines: Int = 0

        func shouldExpand(to text: String) -> Bool {
            guard canExpand else { return false }
            self.text = text
            numberOfLines = maxNumberOfLines
            return true
        }
        
        @discardableResult
        func shouldTruncate() -> Bool {
            maxNumberOfLines = computeMaxNumberOfLines()
            canExpand = maxNumberOfLines > numberOfLines
            guard canExpand else { return false }
            provideReadMoreTail()
            return true
        }
        
        private func provideReadMoreTail() {
            let fullText = text ?? ""
            fullText.range(of: fullText).map {
                let layoutManager = NSLayoutManager()
                let range = NSRange($0, in: fullText)
                let textStorage = NSTextStorage(string: fullText)
                let size = bounds.size
                let textContainer = NSTextContainer(size: size)
                
                textStorage.setAttributes([.font: font], range: range)
                textStorage.addLayoutManager(layoutManager)
                textContainer.lineFragmentPadding = 0
                textContainer.maximumNumberOfLines = numberOfLines
                layoutManager.addTextContainer(textContainer)
                
                let glyphRange = layoutManager.glyphRange(forBoundingRect: bounds, in: textContainer)
                let offset = glyphRange.length - max(style.more.count + style.tail.count, style.maxOffset)
                let endIndex = fullText.index(fullText.startIndex, offsetBy: offset)
                
                let result = NSMutableAttributedString(string: String(fullText[..<endIndex]))
                result.append(NSAttributedString(string: style.tail))
                result.string.range(of: result.string).map {
                    result.addAttribute(.font, value: font, range: NSRange($0, in: result.string))
                    result.addAttribute(.foregroundColor, value: textColor, range: NSRange($0, in: result.string))
                }
                
                result.append(NSAttributedString(string: style.more))
                result.string.range(of: style.more).map {
                    result.addAttribute(.font, value: font,
                                        range: NSRange($0, in: result.string))
                    result.addAttribute(.foregroundColor, value: textColor,
                                        range: NSRange($0, in: result.string))
                    result.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue,
                                        range: NSRange($0, in: result.string))
                    result.addAttribute(.underlineColor, value: textColor,
                                        range: NSRange($0, in: result.string))
                }
                
                attributedText = result
            }
        }
        
        private func computeMaxNumberOfLines() -> Int {
            let maxSize = CGSize(width: frame.size.width, height: .infinity)
            let charSize = font.lineHeight
            let textSize = text?.boundingRect(with: maxSize,
                                              options: .usesLineFragmentOrigin,
                                              attributes: [.font: font],
                                              context: nil)
            if let textSize = textSize {
                return Int(ceil(textSize.height/charSize))
            } else {
                return 0
            }
        }
    }
}
