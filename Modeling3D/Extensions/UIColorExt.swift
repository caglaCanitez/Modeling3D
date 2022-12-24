//
//  UIColorExt.swift
//  Modeling3D
//
//  Created by Cagla Canitez on 24.12.2022.
//

import UIKit

extension UIColor {
    static func purple()-> UIColor {
        return UIColor(named: "purple") ?? .purple
    }
    
    static func background()-> UIColor {
        return UIColor(named: "background") ?? .lightGray
    }
    
    static func text()-> UIColor {
        return UIColor(named: "text") ?? .black
    }
    
    static func blue()-> UIColor {
        return UIColor(named: "blue") ?? .blue
    }
}
