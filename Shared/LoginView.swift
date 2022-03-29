//
//  LoginView.swift
//  HyperClient
//
//  Created by Niko Ma on 3/28/22.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var loginVM = LoginViewModel()
    @EnvironmentObject var authentication: Authentication
    var body: some View {
        VStack {
                Text("HyperClient").font(.largeTitle)
                Text("轻量区块链数据库客户端")
            Spacer()
            Image("ustblogo").resizable().frame(width: 200, height: 200)
                .padding()
            
                TextField("用户名", text: $loginVM.credentials.username)
                SecureField("密码", text: $loginVM.credentials.password)
            if loginVM.showProgressView {
                ProgressView()
            }
            Spacer()
            Button("登录") {
                loginVM.login { success in
                    authentication.updateValidation(success: success)
                }
            }.padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .clipShape(Capsule())
            
            if authentication.biometricType() != .none {
                Button {
                    authentication.requestBiometricUnlock { result in
                        switch result {
                        case .success(let credentials):
                            loginVM.credentials = credentials
                            loginVM.login { success in
                                authentication.updateValidation(success: success)
                            }
                        case .failure(let error):
                            loginVM.error = error
                        }
                    }
                } label: {
                    Image(systemName: authentication.biometricType() == .face ? "faceid" : "touchid")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
            }

        }.textInputAutocapitalization(.none)
            .textFieldStyle(.roundedBorder)
            .padding()
            .disabled(loginVM.showProgressView)
            .alert(item: $loginVM.error) { error in
                if error == .credentialsNotSaved {
                    return Alert(title: Text("登录信息还未保存"), message: Text(error.localizedDescription), primaryButton: .default(Text("确定"), action: {loginVM.storeCredentialsNextTime = true}), secondaryButton: .cancel())
                } else {
                    return Alert(title: Text("无法登录"), message: Text(error.localizedDescription))
                }
            }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().previewDevice("iPhone 13 Pro").environmentObject(Authentication())
    }
}
