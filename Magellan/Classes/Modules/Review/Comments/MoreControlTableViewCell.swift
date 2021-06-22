//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

final class MoreControlTableViewCell: UITableViewCell {
    
    lazy private var iconImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "review_more", in: .frameworkBundle, compatibleWith: nil) ?? UIImage()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 18.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let offset: CGFloat = 8
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutViews() {
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                constant: offset * 2),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -offset * 2),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                constant: 9 * 2),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                constant: -9 * 2),
            iconImageView.heightAnchor.constraint(equalToConstant: 24.0),
            iconImageView.widthAnchor.constraint(equalToConstant: 24.0)
        ])
    }
}

extension MoreControlTableViewCell {
    
    func bind(viewModel: ControlCellViewModelProtocol) {
        titleLabel.text = viewModel.title
    }
    
}


extension MoreControlTableViewCell {
    
    // MARK: CellStyles
    
    struct Default: ViewStyleProtocol {
        
        let style: MagellanStyleProtocol
        
        func apply(to view: UIView) {
            (view as? MoreControlTableViewCell).map {
                $0.selectionStyle = .none
                $0.titleLabel.font = style.regular15
                $0.titleLabel.textColor = style.headerColor
            }
        }
    }
}
