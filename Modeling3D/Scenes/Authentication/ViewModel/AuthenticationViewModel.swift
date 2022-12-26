//
//  AuthenticationViewModel.swift
//  Modeling3D
//
//  Created by Cagla Canitez on 25.12.2022.
//

import Foundation

protocol AuthenticationDelegate: AnyObject {
    func routeToHome()
    func showAlert(title: String, message: String)
}


class AuthenticationViewModel {
    weak var delegate: AuthenticationDelegate?
    
    func userLogin(email: String, password: String) {
        AuthService.login(email: email, password: password) { [weak self] (success, errorMessage) in
            if !success {
                self?.delegate?.showAlert(title: "auth.unableTologin".localize, message: errorMessage ?? "")
                return
            }
            self?.routeToHome()
        }
    }
    
    func userSignup(email: String, password: String, rePassword: String) {
        if password != rePassword {
            self.delegate?.showAlert(title: "auth.passwordDontMatch".localize, message: "auth.passwordDontMatchMessage".localize)
            return
        }
        
        AuthService.signup(email: email, password: password) { [weak self] (success, errorMessage) in
            if !success {
                self?.delegate?.showAlert(title: "auth.unableToSignup".localize, message: errorMessage ?? "")
                return
            }
            self?.routeToHome()
        }
    }
    
    func userUpdatePassword(email: String) {
        AuthService.updatePassword(email: email) { [weak self]  (success, errorMessage) in
            if !success {
                self?.delegate?.showAlert(title: "auth.unableToSendResetMail".localize, message: errorMessage ?? "")
                return
            }
            self?.delegate?.showAlert(title: "auth.sendResetMail".localize, message: "auth.sendResetMailMessage".localize)
        }
    }
    
    private func routeToHome(){
        UserDefaults.standard.setValue(true, forKey: GeneralConstants.UserDefault.isLoginState)
        self.delegate?.routeToHome()
    }
}
