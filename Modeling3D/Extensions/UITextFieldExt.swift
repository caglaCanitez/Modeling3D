//
//  UITextFieldExt.swift
//  Modeling3D
//
//  Created by Cagla Canitez on 24.12.2022.
//

import UIKit

extension UITextField {
    
    func setIcon(_ image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
        iconView.image = image
        
        let iconContainerView: UIView = UIView(frame: CGRect(x: 20, y: 0, width: 35, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
    
    func setDefault(iconName: String, placeHolder: String) {
        let attribute = [ NSAttributedString.Key.foregroundColor: UIColor.purple().withAlphaComponent(0.6) ]
        let attributeStr = NSAttributedString(string: placeHolder.localize, attributes: attribute)
        
        let icon = (UIImage(systemName: iconName)!.withTintColor(UIColor.purple(), renderingMode: .alwaysOriginal))
        
        self.setIcon(icon)
        self.attributedPlaceholder = attributeStr
        self.backgroundColor = UIColor(white: 1, alpha: 0.4)
        self.textColor = UIColor.purple()
        self.layer.cornerRadius = 15
    }
    
}
