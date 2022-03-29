//
//  LoginViewModel.swift
//  HyperClient
//
//  Created by Niko Ma on 3/28/22.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var credentials = Credentials()
    @Published var showProgressView = false
    @Published var error: Authentication.AuthenticationError?
    @Published var storeCredentialsNextTime = false
    
    func login(completion: @escaping (Bool) -> Void) {
        showProgressView = true
        HyperClient.shared.login(credentials: credentials) { [unowned self] result in
            showProgressView = false
            switch result {
            case .success:
                if storeCredentialsNextTime {
                    do {
                        let data = try JSONEncoder().encode(credentials)
                        UserDefaults.standard.set(data, forKey: "Default")
                    } catch {
                        print("UserDefaults set failed: \(error.localizedDescription)")
                    }
                    storeCredentialsNextTime = false
                }
                completion(true)
            case .failure(let authError):
                credentials = Credentials()
                error = authError
                completion(false)
            }
        }
    }
}
