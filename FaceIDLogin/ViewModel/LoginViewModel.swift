//
//  LoginViewModel.swift
//  FaceIDLogin
//
//  Created by Onur Celik on 28.03.2023.
//

import SwiftUI
import Firebase
import LocalAuthentication
class LoginViewModel: ObservableObject{
    @Published var email = ""
    @Published var password = ""
    
    @Published var showAlert = false
    @Published var errorMessage = ""
    
    @AppStorage ("use_face_id") var useFaceId: Bool = false
    // Keychain Properties
    
    @Keychain (key:"use_face_email",account: "FaceIdLogin") var storedEmail
    @Keychain (key:"use_face_password",account: "FaceIdLogin") var storedPassword
    @AppStorage ("log_status") var logStatus: Bool = false
    
    func loginUser(useFaceId:Bool,email:String = "",password:String = "")async throws{
        let _ = try await Auth.auth().signIn(withEmail: email != "" ? email : self.email, password: password != "" ? password : self.password)
        DispatchQueue.main.async {
            // Storing once
            if useFaceId && self.storedEmail == nil{
                // Storing for future faceId login
                self.useFaceId = useFaceId
                let emailData = self.email.data(using: .utf8)
                let passwordData = self.password.data(using: .utf8)
                self.storedEmail = emailData
                self.storedPassword = passwordData
            }
            self.logStatus = true
        }
    }
    func getBiometricStatus()->Bool{
        return LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: .none)
        
    }
    func authenticateUser()async throws{
        let status = try await LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To Login")
        if let emailData = storedEmail,let passwordData = storedPassword,status{
            try await loginUser(
                useFaceId: useFaceId,
                email: String(data: emailData, encoding: .utf8) ?? "",
                password: String(data: passwordData, encoding: .utf8) ?? "")
        }
    }
}
