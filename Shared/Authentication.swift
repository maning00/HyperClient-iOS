//
//  Authentication.swift
//  HyperClient
//
//  Created by Niko Ma on 3/28/22.
//

import SwiftUI
import LocalAuthentication

struct Credentials: Codable {
    var username: String = ""
    var password: String = ""
}

class Authentication: ObservableObject {
    @Published var isValidated = false
    @Published var isAuthorized = false
    
    enum BiometricType {
        case none
        case face
        case touch
    }
    
    enum AuthenticationError: Error, LocalizedError, Identifiable {
            case invalidCredentials
            case deniedAccess
            case noFaceIdEnrolled
            case noFingerprintEnrolled
            case biometrictError
            case credentialsNotSaved
            
            var id: String {
                self.localizedDescription
            }
            
            var errorDescription: String? {
                switch self {
                case .invalidCredentials:
                    return NSLocalizedString("账号密码错误，请重新输入", comment: "")
                case .deniedAccess:
                    return NSLocalizedString("请在设置中打开本app的Face ID权限", comment: "")
                case .noFaceIdEnrolled:
                    return NSLocalizedString("您还没有录入任何Face ID", comment: "")
                case .noFingerprintEnrolled:
                    return NSLocalizedString("您还没有录入任何Touch ID", comment: "")
                case .biometrictError:
                    return NSLocalizedString("无法识别您", comment: "")
                case .credentialsNotSaved:
                    return NSLocalizedString("您希望保存账号密码以便下次登录吗？", comment: "")
                }
            }
        }
    
    func updateValidation(success: Bool) {
        withAnimation {
            isValidated = success
        }
    }
    
    func biometricType() -> BiometricType {
        let authContext = LAContext()
        let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        
        switch authContext.biometryType {
            
        case .none:
            return .none
        case .touchID:
            return .touch
        case .faceID:
            return .face
        @unknown default:
            return .none
        }
    }
    
    func requestBiometricUnlock(completion: @escaping (Result<Credentials, AuthenticationError>) -> Void) {
        var credentials: Credentials? = nil
        if let data = UserDefaults.standard.data(forKey: "Default") {
            do {
                credentials = try JSONDecoder().decode(Credentials.self, from: data)
            } catch {
                print("Decode Userdefaults error: \(error.localizedDescription)")
                completion(.failure(.credentialsNotSaved))
                return
            }
        }
            
        guard let credentials = credentials else {
            completion(.failure(.credentialsNotSaved))
            return
        }
        
        let context = LAContext()
        var error: NSError?
        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if let error = error {
            switch error.code {
            case -6:
                completion(.failure(.deniedAccess))
            case -7:
                if context.biometryType == .faceID {
                    completion(.failure(.noFaceIdEnrolled))
                } else {
                    completion(.failure(.noFingerprintEnrolled))
                }
            default:
                completion(.failure(.biometrictError))
            }
            return
        }
        
        // Determine whether it can recognize identity
        if canEvaluate {
            if context.biometryType != .none {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "需要读取登录信息") { success, error in
                    DispatchQueue.main.async {
                        if error != nil {
                            completion(.failure(.biometrictError))
                        } else {
                            completion(.success(credentials))
                        }
                    }
                }
            }
        }
    }
}
