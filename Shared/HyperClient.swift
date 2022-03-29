//
//  HyperClient.swift
//  HyperClient
//
//  Created by Niko Ma on 3/28/22.
//

import Foundation
import Alamofire



struct HyperClient {
    static let shared = HyperClient()
    
    public func login(credentials: Credentials, completion: @escaping (Result<Bool, Authentication.AuthenticationError>) -> Void) {
        AF.request("http://192.168.31.125:5000/api/v1/login", method: .post).validate().responseDecodable(of: [String:String].self) { response in
            if let response = response.value {
                if response["result"] == "OK" {
                    completion(.success(true))
                    return
                } else {
                    completion(.failure(.invalidCredentials))
                }
            }
        }
    }
    
}
