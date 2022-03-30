//
//  HyperClient.swift
//  HyperClient
//
//  Created by Niko Ma on 3/28/22.
//

import Foundation
import Alamofire
import CryptoKit
import Logging

let logger = Logger(label: "HyperClient")

struct Entry: Codable {
    var name: String
    var timestamp: UInt32
    var author: String
    var email: String
    var institution: String
    var environment: String
    var parameters: String
    var details: String
    var attachment: String
    var hash: String
    
    public func calHash() -> String {
        let data = "\(self.name)\(self.timestamp)\(self.author)\(self.email)\(self.institution)\(self.environment)\(self.parameters)\(self.details)\(self.attachment)".data(using: .utf8)!
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02hhx", $0) }.joined()
    }
}


struct AuthenticResponse: Codable {
    let timestamp: String
    let item: String
    let proof: [String]
    let result: Bool
}

struct ResponsePair: Codable {
    let data: Entry
    let authentication: AuthenticResponse
}

struct HyperClient {
    static var shared = HyperClient()
    
    var experimentalData = [ResponsePair]()
    
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
    

    mutating func fetchData() {
        /**
         Request (3)
         post http://192.168.31.125:5000/api/v1/get_data
         */
        var res = self
        // Add Headers
        let headers: HTTPHeaders = [
            "Content-Type":"application/json; charset=utf-8"
        ]

        // JSON Body
        let body: [String : Any] = [
            "table_name": "diva@testnet.ustb.edu"
        ]

        // Fetch Request
        AF.request("http://192.168.31.125:5000/api/v1/get_data", method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [ResponsePair].self) { response in
                switch response.result {
                case .success(let responsePairs):
                    res.experimentalData.append(contentsOf: responsePairs)
                case .failure(let error):
                    logger.error("\(error.localizedDescription)")
                }
            }
        
        self = res
    }
    
    mutating func insertData(data: Entry) {
        // Add Headers
        let headers: HTTPHeaders = [
            "Content-Type":"application/json; charset=utf-8",
        ]

        // JSON Body
        let body: [String : Any] = [
            "data": data.dictionary
        ]

        // Fetch Request
        AF.request("http://192.168.31.125:5000/api/v1/insert?height=1", method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .response { response in
                debugPrint(response)
            }
    }

}
