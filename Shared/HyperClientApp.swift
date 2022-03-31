//
//  HyperClientApp.swift
//  Shared
//
//  Created by Niko Ma on 3/25/22.
//

import SwiftUI

@main
struct HyperClientApp: App {
    @StateObject var authentication = Authentication()
    @StateObject var document = ClientViewModel()
    var body: some Scene {
        WindowGroup {
            if authentication.isValidated {
                ContentView(document: document)
                    .environmentObject(authentication)
            } else {
                LoginView(loginVM: document)
                    .environmentObject(authentication)
            }
        }
    }
}
