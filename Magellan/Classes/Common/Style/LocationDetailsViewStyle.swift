//
/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

public protocol LocationDetailsViewStyleProtocol {
    
    var viewBackgroundColor: UIColor { get }
    var headerViewBackgroundColor: UIColor { get }
    var panViewBackgroundColor: UIColor { get }
    
    var panViewCornerRadius: CGFloat { get }
    
    var nameLabelFont: UIFont { get }
    var categoryLabelFont: UIFont { get }
    var categoryLabelTextColor: UIColor { get }
    
    var workingHoursLabelFont: UIFont { get }
    var workingHoursLabelTextColor: UIColor { get }
    
    var distanceFont: UIFont { get }
    var distanceColor: UIColor { get }
    
    var separatorInsets: UIEdgeInsets { get }
    
    var panHeight: CGFloat { get }
    var panWidth: CGFloat { get }
    
    var offset: CGFloat { get }
    var sideOffset: CGFloat { get }
    var buttonSideSize: CGFloat { get }
    
}

struct DefaultLocationDetailsViewStyle: LocationDetailsViewStyleProtocol {
    
    let viewBackgroundColor: UIColor = UIColor.Style.background
    let headerViewBackgroundColor: UIColor = .white
    let panViewBackgroundColor: UIColor = UIColor.Style.pan
    let panViewCornerRadius: CGFloat = MapConstants.panHeight / 2
    let nameLabelFont: UIFont = .styleFont(for: .title2)
    let categoryLabelFont: UIFont = .styleFont(for: .favoriteCard)
    let categoryLabelTextColor: UIColor = UIColor(red: 0.539, green: 0.539, blue: 0.539, alpha: 1)
    let workingHoursLabelFont: UIFont = .styleFont(for: .favoriteCard)
    let workingHoursLabelTextColor: UIColor = UIColor.Style.Text.mapOpened
    let distanceFont: UIFont = .styleFont(for: .favoriteCard)
    let distanceColor: UIColor = UIColor(red: 0.539, green: 0.539, blue: 0.539, alpha: 1)
    let separatorInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    let panHeight: CGFloat = MapConstants.panHeight
    let panWidth: CGFloat = 36
    let offset: CGFloat = 4
    let sideOffset: CGFloat = 20
    let buttonSideSize:CGFloat = 40
}
