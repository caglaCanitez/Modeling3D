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
                print("login res id: ", res?.user.uid)
                UserDefaults.standard.set(true, forKey: "status")
                completion(true, nil)
            }
        }
    }
    
    static func signup(email: String, password: String, completion: @escaping (_ success: Bool, _ errorMessage: String?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            
            if err != nil {
                completion(false, err?.localizedDescription ?? "")
                return
            } else {
                //guard let userId = res?.user.uid else { return }
                print("signup res id: ", res?.user.uid)
                self.verifyEmailForSignup(user: res?.user) { success, errorMessage in
                    if success {
                        UserDefaults.standard.set(true, forKey: "status")
                        completion(true, nil)
                    } else {
                        completion(false, errorMessage)
                    }
                }
            }
        }
    }
    
    static func updatePassword(email: String, completion: @escaping (_ success: Bool, _ errorMessage: String?) -> ()) {
        Auth.auth().sendPasswordReset(withEmail: email) { err in
            if err != nil {
                completion(false, err?.localizedDescription ?? "")
                return
            } else {
                UserDefaults.standard.set(true, forKey: "status")
                completion(true, nil)
            }
        }
    }
    
    static func verifyEmailForSignup(user: User?, completion: @escaping (_ success: Bool, _ errorMessage: String?) -> ()) {
        if user != nil && !user!.isEmailVerified {
            user!.sendEmailVerification(completion: { (error) in
                if error != nil {
                    completion(false, error?.localizedDescription ?? "")
                    return
                } else {
                    completion(true, nil)
                }
            })
          } else {
            // Either the user is not available, or the user is already verified.
          }
    }
}
