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
    var body: some Scene {
        WindowGroup {
            if authentication.isValidated {
                ContentView()
                    .environmentObject(authentication)
            } else {
                LoginView()
                    .environmentObject(authentication)
            }
        }
    }
}
