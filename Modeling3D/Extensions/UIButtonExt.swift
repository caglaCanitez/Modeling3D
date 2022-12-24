//
//  UIButtonExt.swift
//  Modeling3D
//
//  Created by Cagla Canitez on 24.12.2022.
//

import UIKit

extension UIButton {
    private func setDefaultButton(buttonName: String) {
        self.setTitle(buttonName.localize, for: .normal)
        self.setTitleColor(UIColor.purple(), for: .normal)
        self.layer.cornerRadius = 15
    }
    
    func setDefaultClearButton(buttonName: String, fontSize: CGFloat) {
        setDefaultButton(buttonName: buttonName)
        self.titleLabel!.font = UIFont.appMainBold(fontSize: fontSize)
        self.backgroundColor = .clear
    }
    
    func setDefaultAppButton(buttonName: String, fontSize: CGFloat) {
        setDefaultButton(buttonName: buttonName)
        self.titleLabel!.font = UIFont.appMainBold(fontSize: fontSize)
        self.backgroundColor = UIColor.blue()
    }
}
