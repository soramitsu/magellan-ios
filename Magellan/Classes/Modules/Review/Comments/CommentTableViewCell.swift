//
/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: GPL-3.0
 */


import Foundation
import SoraUI

final class CommentTableViewCell: UITableViewCell {
    
    private let offset: CGFloat = 8
    
    private(set) var strategy: TruncateStrategy?
    
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
        strategy?.truncate(view: messageLabel)
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
    
    var expandingView: UILabel { messageLabel }
    
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
                
                $0.strategy = TruncateStrategy(fullText: $0.messageLabel.text ?? "",
                                               style: .init(foregroundColor: style.darkTextColor,
                                                            font: style.semiBold14))
                
                
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

extension UILabel {
    
    var maxNumberOfLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: .infinity)
        let charSize = font.lineHeight
        let textSize = text?.boundingRect(with: maxSize,
                                          options: .usesLineFragmentOrigin,
                                          attributes: [.font: font],
                                          context: nil)
        if let textSize = textSize {
            return Int(ceil(textSize.height/charSize))
        } else {
            return 1
        }
    }
    
}

final class TruncateStrategy {
    
    internal init(fullText: String, style: ReadMoreStyle) {
        self.fullText = fullText
        self.style = style
    }
    
    struct ReadMoreStyle {
        let foregroundColor: UIColor
        let font: UIFont
    }
    
    let style: ReadMoreStyle
    let readMore: String = "More"
    let tail: String = "... "
    let fullText: String
    var maxLines: Int = 0
    var maxRightOffset: Int = 40

    func shouldExpand(view: UILabel) -> Bool {
        guard view.numberOfLines < maxLines else { return false }
        view.text = fullText
        view.numberOfLines = maxLines
        return true
    }
    
    func truncate(view: UILabel) {
        
        guard view.maxNumberOfLines > view.numberOfLines else { return }
        maxLines = 0
        
        fullText.range(of: fullText).map {
            let layoutManager = NSLayoutManager()
            let range = NSRange($0, in: fullText)
            let textStorage = NSTextStorage(string: fullText)
            let size = view.bounds.size
            let textContainer = NSTextContainer(size: size)
            
            textStorage.setAttributes([.font: view.font], range: range)
            textStorage.addLayoutManager(layoutManager)
            textContainer.lineFragmentPadding = 0
            textContainer.maximumNumberOfLines = view.numberOfLines
            layoutManager.addTextContainer(textContainer)
            
            let glyphRange = layoutManager.glyphRange(forBoundingRect: view.bounds, in: textContainer)
            let offset = glyphRange.length - max(readMore.count + tail.count, maxRightOffset)
            let endIndex = fullText.index(fullText.startIndex, offsetBy: offset)
            
            let result = NSMutableAttributedString(string: String(fullText[..<endIndex]))
            result.append(NSAttributedString(string: tail))
            result.string.range(of: result.string).map {
                result.addAttribute(.font, value: view.font, range: NSRange($0, in: result.string))
                result.addAttribute(.foregroundColor, value: view.textColor, range: NSRange($0, in: result.string))
            }
            
            result.append(NSAttributedString(string: readMore))
            result.string.range(of: readMore).map {
                result.addAttribute(.font, value: style.font,
                                    range: NSRange($0, in: result.string))
                result.addAttribute(.foregroundColor, value: style.foregroundColor,
                                    range: NSRange($0, in: result.string))
                result.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue,
                                    range: NSRange($0, in: result.string))
                result.addAttribute(.underlineColor, value: style.foregroundColor,
                                    range: NSRange($0, in: result.string))
            }
            
            view.attributedText = result
        }
        
    }
}
