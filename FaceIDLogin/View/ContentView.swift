//
//  ContentView.swift
//  FaceIDLogin
//
//  Created by Onur Celik on 28.03.2023.
//

import SwiftUI

struct ContentView: View {
    @AppStorage ("log_status") var logStatus: Bool = false
    var body: some View {
        NavigationView{
            if logStatus{
                HomeView()
            }else{
                LoginPage()
                    .navigationBarHidden(true)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

