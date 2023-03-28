//
//  LoginPage.swift
//  FaceIDLogin
//
//  Created by Onur Celik on 28.03.2023.
//

import SwiftUI

struct LoginPage: View {
    @StateObject var viewModel = LoginViewModel()
    
    @State var useFaceId: Bool = false
    var body: some View {
        VStack{
            Text("Hey, \nLogin Now")
                .font(.largeTitle)
                .foregroundColor(.primary)
                .hLeading()
            
            TextField("Email", text: $viewModel.email)
                .padding()
                .background{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            viewModel.email == "" ? .black.opacity(0.05) : .yellow
                        )
                }
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $viewModel.password)
                .padding()
                .background{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            viewModel.password == "" ? .black.opacity(0.05) : .yellow
                        )
                }
                .textInputAutocapitalization(.never)
            if viewModel.getBiometricStatus(){
                Group{
                    if viewModel.useFaceId{
                        Button {
                            // faceid action
                            Task{
                                do{
                                    try await viewModel.authenticateUser()
                                }catch{
                                    viewModel.showAlert.toggle()
                                    viewModel.errorMessage = error.localizedDescription
                                }
                                
                            }
                            
                        } label: {
                            VStack(alignment:.leading,spacing: 10){
                                Label {
                                    Text("Use FaceID to login into previous account")
                                } icon: {
                                    Image(systemName: "faceid")
                                }
                                .font(.caption)
                                .foregroundColor(.secondary)
                                
                                Text("You can turn off it in settings")
                                    .foregroundColor(.secondary)
                                    .font(.caption2)
                                

                            }
                        }
                        .padding(.vertical,20)
                        .hLeading()

                    }else{
                        Toggle(isOn: $useFaceId) {
                            Text("Use FaceID to Login")
                                .foregroundColor(.secondary)
                        }
                    }

                }
            }
            
            Button {
                Task{
                    do{
                        try await viewModel.loginUser(useFaceId: useFaceId)
                    }catch{
                        viewModel.showAlert.toggle()
                        viewModel.errorMessage = error.localizedDescription
                    }
                }
            } label: {
                Text("Login")
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.blue)
                    }
            }
            .padding(.vertical)
            .disabled(viewModel.email == "" || viewModel.password == "")
            .opacity(viewModel.email == "" || viewModel.password == "" ? 0.5 : 1.0)
            
           


        }
        .padding(.horizontal,25)
        .padding(.vertical)
        .alert(viewModel.errorMessage, isPresented: $viewModel.showAlert) {
            
        }
        
        
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}
extension View{
    func hLeading()->some View{
        self
            .frame(maxWidth:.infinity,alignment: .leading)
    }
    func hTrailing()->some View{
        self
            .frame(maxWidth:.infinity,alignment: .trailing)
    }
    func hCenter()->some View{
        self
            .frame(maxWidth:.infinity,alignment: .center)
    }
}
