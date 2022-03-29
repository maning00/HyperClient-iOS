//
//  ContentView.swift
//  Shared
//
//  Created by Niko Ma on 3/25/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authentication: Authentication
    var body: some View {
        NavigationView {
            VStack {
                Text("Authorized!")
                Button("注销") {
                    authentication.updateValidation(success: false)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
