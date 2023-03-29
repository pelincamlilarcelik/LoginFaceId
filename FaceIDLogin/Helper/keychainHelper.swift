//
//  keychainHelper.swift
//  FaceIDLogin
//
//  Created by Onur Celik on 29.03.2023.
//

import SwiftUI

class KeychainHelper{
    static let standart = KeychainHelper()
    
    func save(data:Data,key:String,account:String){
        // Creating query
        
        let query = [
            kSecValueData: data,
            kSecAttrAccount: account,
            kSecAttrService: key,
            kSecClass: kSecClassGenericPassword
            ] as CFDictionary
        // Adding data to keychain
        let status = SecItemAdd(query, nil)
        // Cheking for status
        switch status{
        case errSecSuccess: print("Success")
        case errSecDuplicateItem:
            let updateQuery = [
                kSecAttrAccount: account,
                kSecAttrService: key,
                kSecClass: kSecClassGenericPassword
                ] as CFDictionary
            let updateAttr = [kSecValueData: data] as CFDictionary
            SecItemUpdate(updateQuery, updateAttr)
        default: print("Error \(status)")
        }
    }
    func read(key:String,account:String)-> Data?{
        let query = [
            kSecAttrAccount: account,
            kSecAttrService: key,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData:true,
            
            ] as CFDictionary
        // to copy the data
        var resultData:AnyObject?
        SecItemCopyMatching(query, &resultData)
        return resultData as? Data
    }
    func delete(key:String,account:String){
        let query = [
            kSecAttrAccount: account,
            kSecAttrService: key,
            kSecClass: kSecClassGenericPassword,
            ] as CFDictionary
        SecItemDelete(query)
    }
}
