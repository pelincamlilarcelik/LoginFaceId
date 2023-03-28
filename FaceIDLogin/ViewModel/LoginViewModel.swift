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
    @AppStorage ("use_face_email") var faceIdEmail = ""
    @AppStorage ("use_face_password") var faceIdPassword = ""
    @AppStorage ("log_status") var logStatus: Bool = false
    
    func loginUser(useFaceId:Bool,email:String = "",password:String = "")async throws{
        let _ = try await Auth.auth().signIn(withEmail: email != "" ? email : self.email, password: password != "" ? password : self.password)
        DispatchQueue.main.async {
            // Storing once
            if useFaceId && self.faceIdEmail == ""{
                // Storing for future faceId login
                self.useFaceId = useFaceId
                self.faceIdEmail = self.email
                self.faceIdPassword = self.password
            }
            self.logStatus = true
        }
    }
    func getBiometricStatus()->Bool{
        return LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: .none)
        
    }
    func authenticateUser()async throws{
        let status = try await LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To Login")
        if status{
            try await loginUser(useFaceId: useFaceId,email: faceIdEmail,password: faceIdPassword)
        }
    }
}
