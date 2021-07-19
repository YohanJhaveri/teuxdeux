//
//  Validator.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/6/21.
//

import Foundation
import Firebase

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
    
    private static func isValidEmail(_ email: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: email)
    }
    
    private static func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8
    }
    
    
    static func handleAuth(from type: AuthType, email: String, password: String, _ callback: @escaping ([String: String]) -> Void) {
        var errors: [String: String] = [:]
        
        if !isValidEmail(email) {
            errors["email"] = "Email is badly formatted"
        }
        
        if !isValidPassword(password) {
            errors["password"] = "Password must contain at least 8 characters"
        }
        
        if !errors.isEmpty {
            callback(errors)
            return
        }
                
        let handleResponse = { (authResult: AuthDataResult?, error: Error?) in
            if let error = error {
                errors["email"] = ""
                errors["password"] = error.localizedDescription
            }
            
            callback(errors)
        }
        
        switch type {
            case .start: self.auth.createUser(withEmail: email, password: password, completion: handleResponse)
            case .login: self.auth.signIn(withEmail: email, password: password, completion: handleResponse)
        }
    }
}
