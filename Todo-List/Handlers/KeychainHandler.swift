//
//  KeychainHandler.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/20/21.
//

import Foundation

class KeychainHandler {
    static func savePassword(email: String, password: String) {
        guard let passwordData = password.data(using: .utf8) else {
            print("Error converting value to data")
            return
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email,
            kSecAttrService as String: "auth",
            kSecValueData as String: passwordData
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecDuplicateItem {
            updatePassword(
                email: email,
                password: password
            )
        }
    }
    
    static func getPassword(email: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email,
            kSecAttrService as String: "auth",
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status != errSecItemNotFound else {
            print("Item could not be found")
            return nil
        }
        
        guard status == errSecSuccess else {
            print("Services error")
            return nil
        }
        
        guard
            let existingItem = item as? [String: Any],
            let valueData = existingItem[kSecValueData as String] as? Data,
            let value = String(data: valueData, encoding: .utf8)
        else {
            print("Unable to convert to string")
            return nil
        }
        
        return value
    }
    
    static func updatePassword(email: String, password: String) {
        guard let passwordData = password.data(using: .utf8) else {
            print("Error converting value to data")
            return
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email,
            kSecAttrService as String: "auth"
        ]
        
        let attributes: [String: Any] = [
            kSecValueData as String: passwordData
        ]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        
        guard status != errSecItemNotFound else {
            print("Matching item could not be found")
            return
        }
        
        guard status == errSecSuccess else {
            print("Services error")
            return
        }
    }
}
