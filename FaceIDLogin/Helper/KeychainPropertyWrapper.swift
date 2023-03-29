//
//  KeychainPropertyWrapper.swift
//  FaceIDLogin
//
//  Created by Onur Celik on 29.03.2023.
//

import SwiftUI
// Custom Wrapper For Keychain
@propertyWrapper
struct Keychain : DynamicProperty{
    @State var data: Data?
    
    var wrappedValue: Data?{
        get{data}
        nonmutating set{
            guard let newData = newValue else{
                data = nil
                KeychainHelper.standart.delete(key: key, account: account)
                return
            }
            
            KeychainHelper.standart.save(data: newData, key: key, account: account)
            //Updating data
            data = newValue
        }
    }
    var key: String
    var account: String
    init(key: String, account: String) {
        self.key = key
        self.account = account
        // Setting initial state keychain data
        _data = State(wrappedValue: KeychainHelper.standart.read(key: key, account: account))
    }
}
