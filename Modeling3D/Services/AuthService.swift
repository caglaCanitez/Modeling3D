//
//  AuthService.swift
//  Modeling3D
//
//  Created by Cagla Canitez on 25.12.2022.
//

import Foundation
import FirebaseAuth

class AuthService {
    
    static func login(email: String, password: String, completion: @escaping (_ success: Bool, _ errorMessage: String?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            if err != nil {
                completion(false, err?.localizedDescription ?? "")
                return
            } else {
                //guard let userId = res?.user.uid else { return }
                print("res id: ", res?.user.uid)
                UserDefaults.standard.set(true, forKey: "status")
                completion(true, nil)
            }
        }
    }
    
    static func signup(email: String, password: String, verifyCode: String, completion: @escaping (_ success: Bool, _ errorMessage: String?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            
            if err != nil {
                completion(false, err?.localizedDescription ?? "")
                return
            } else {
                //guard let userId = res?.user.uid else { return }
                UserDefaults.standard.set(true, forKey: "status")
                completion(true, nil)
            }
        }
    }
    
    static func updatePassword(email: String, newPassword: String, verifyCode: String, completion: @escaping (_ success: Bool, _ errorMessage: String?) -> ()) {
//        AGCAuth.instance().resetPassword(withEmail:email, newPassword:newPassword, verifyCode: verifyCode)
//        .onSuccess{ (result) in
//            completion(true, nil)
//        }.onFailure{ (error) in
//            completion(false, error.localizedDescription)
//        }
    }
    
    static func verifyCodeForSignup(email: String, completion: @escaping (_ success: Bool, _ errorMessage: String?) -> ()) {
//        let setting = AGCVerifyCodeSettings.init(action:AGCVerifyCodeAction.registerLogin, locale:nil, sendInterval:30)
//        AGCEmailAuthProvider.requestVerifyCode(withEmail: email, settings: setting).onSuccess { (result) in
//            completion(true, nil)
//        }.onFailure{ (error) in
//            completion(false, error.localizedDescription)
//        }
    }
    
    static func verifyCodeForResetPassword (email: String, completion: @escaping (_ success: Bool, _ errorMessage: String?) -> ()) {
//        let setting = AGCVerifyCodeSettings.init(action:AGCVerifyCodeAction.resetPassword, locale:nil, sendInterval:30)
//        AGCEmailAuthProvider.requestVerifyCode(withEmail:email, settings:setting).onSuccess{ (result) in
//            completion(true, nil)
//        }.onFailure{ (error) in
//            completion(false, error.localizedDescription)
//        }
    }
}
