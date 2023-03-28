//
//  HomeView.swift
//  FaceIDLogin
//
//  Created by Onur Celik on 28.03.2023.
//

import SwiftUI
import Firebase

struct HomeView: View {
    @AppStorage ("log_status") var logStatus: Bool = false
    @AppStorage ("use_face_id") var useFaceId: Bool = false
    @AppStorage ("use_face_email") var faceIdEmail = ""
    @AppStorage ("use_face_password") var faceIdPassword = ""
    var body: some View {
        VStack(spacing: 20) {
            if logStatus{
                Text("Logged In")
                Button {
                    do{
                        try Auth.auth().signOut()
                        logStatus = false
                    }catch{
                        print("Failed to log out")
                    }
                } label: {
                    Text("Logout")
                }

            }else{
                Text("Came as guest")
            }
            if useFaceId{
                Button("Disable FaceID"){
                    useFaceId = false
                    faceIdEmail = ""
                    faceIdPassword = ""
                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("Home")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
