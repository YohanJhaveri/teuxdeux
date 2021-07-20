//
//  AuthHandler.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/6/21.
//

import Foundation
import Firebase
import LocalAuthentication


//enum AuthError: Error {
//    case invalidEmail // self check + FIRAuthErrorCodeInvalidEmail
//    case shortPassword // self check
//
//    case networkError // FIRAuthErrorCodeNetworkError
//    case userNotFound // FIRAuthErrorCodeUserNotFound
//    case userTokenExpired // FIRAuthErrorCodeUserTokenExpired
//    case tooManyRequests // FIRAuthErrorCodeTooManyRequests
//    case invalidAPIKey // FIRAuthErrorCodeInvalidAPIKey
//    case appNotAuthorized // FIRAuthErrorCodeAppNotAuthorized
//    case keychainError // FIRAuthErrorCodeKeychainError
//    case internalError // FIRAuthErrorCodeInternalError
//
//    case emailInUse // FIRAuthErrorCodeEmailAlreadyInUse
//    case disabledOperation // FIRAuthErrorCodeOperationNotAllowed
//    case disabledUser // FIRAuthErrorCodeUserDisabled
//    case wrongPassword // FIRAuthErrorCodeWrongPassword
//    case weakPassword // FIRAuthErrorCodeWeakPassword
//}


enum AuthType {
    case start
    case login
}

struct AuthHandler {
    private static let auth = Auth.auth()
    private static let userDefaults = UserDefaults.standard
    
    
    private static func isValidEmail(_ email: String) -> Bool {
        return email.isEmailFormat
    }
    
    
    private static func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8
    }
    
    
    private static func getErrors(email: String, password: String) -> [String: String] {
        var errors: [String: String] = [:]
        
        if !isValidEmail(email) {
            errors["email"] = "Email is badly formatted"
        }
        
        if !isValidPassword(password) {
            errors["password"] = "Password must contain at least 8 characters"
        }
        
        return errors
    }

    
    private static func setUserHasAccount() {
        userDefaults.setValue(true, forKey: Defaults.hasAccount)
    }
    
    
    static func handleAuth(from type: AuthType, email: String, password: String, _ callback: @escaping ([String: String]?) -> Void) {
        let errors = getErrors(email: email, password: password)
        
        if !errors.isEmpty {
            callback(errors)
            return
        }
        
        let handleResponse = { (authResult: AuthDataResult?, error: Error?) in
            if error == nil {
                
                KeychainHandler.savePassword(email: email, password: password)
                
            } else if password != KeychainHandler.getPassword(email: email) {
                
                callback([
                    "email": "",
                    "password": error!.localizedDescription
                ])
                
                return
                
            }
            
            setUserHasAccount()
            callback(nil)
        }
        
        switch type {
        case .start: self.auth.createUser(withEmail: email, password: password, completion: handleResponse)
        case .login: self.auth.signIn(withEmail: email, password: password, completion: handleResponse)
        }
    }
    
    
    static func handleBiometrics(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to unlock your note."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { authenticated, error in
                if let error = error {
                    print("\(error)")
                }
                
                if authenticated {
                    setUserHasAccount()
                }
                
                completion(authenticated)
            }
            
        } else {
            
            if let errorString = error?.localizedDescription {
                print("Error in biometric policy evaluation: \(errorString)")
                completion(false)
            }
        }
    }
}
