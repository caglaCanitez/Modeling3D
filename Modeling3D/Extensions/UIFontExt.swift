//
//  UIFontExt.swift
//  Modeling3D
//
//  Created by Cagla Canitez on 24.12.2022.
//

import UIKit

extension UIFont {
    static func appMainRegular(fontSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize)
    }
    
    static func appMainBold(fontSize: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: fontSize)
    }
}
