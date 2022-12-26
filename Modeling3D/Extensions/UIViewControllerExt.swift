//
//  UIViewControllerExt.swift
//  Modeling3D
//
//  Created by Cagla Canitez on 25.12.2022.
//

import UIKit

extension UIViewController: AuthenticationDelegate {
    func routeToHome() {
//        let vc = LoginViewController()
//        vc.modalPresentationStyle = .fullScreen
//        self.show(vc, sender: self)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "alert.click".localize, style: UIAlertAction.Style.default, handler: nil))
        self.showDetailViewController(alert, sender: self)
    }
}
