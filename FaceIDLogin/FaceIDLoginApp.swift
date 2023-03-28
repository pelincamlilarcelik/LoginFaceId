//
//  FaceIDLoginApp.swift
//  FaceIDLogin
//
//  Created by Onur Celik on 28.03.2023.
//

import SwiftUI
import FirebaseCore
@main
struct FaceIDLoginApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
