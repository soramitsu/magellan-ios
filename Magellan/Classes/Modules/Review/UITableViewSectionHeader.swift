//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

final class UITableViewSectionHeader: UITableViewHeaderFooterView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Header title"
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        layoutViews()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutViews() {
        contentView.addSubview(titleLabel)
        let bottomAnchor = titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14.0)
        bottomAnchor.priority = .defaultHigh
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                            constant: 14.0),
            bottomAnchor,
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: 16.0)
        ])
    }
    
    private func configureViews() {
        contentView.backgroundColor = .white
    }
}

extension UITableViewSectionHeader: Bindable {
    
    func bind(viewModel: ViewModelProtocol) {
        titleLabel.text = (viewModel as? ReviewSectionViewModel)?.title
    }
}
