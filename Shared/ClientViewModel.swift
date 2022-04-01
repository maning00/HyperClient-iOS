//
//  ClientViewModel.swift
//  HyperClient
//
//  Created by Niko Ma on 3/29/22.
//

import SwiftUI

class ClientViewModel: ObservableObject {
    @Published var showProgressView = false
    @Published var rawData: [ResponsePair]?
    
    
    @MainActor
    public func fetchData() async {
        logger.info("Fetching data...")
        
        rawData = await HyperClient.shared.fetchData()
    }
    
    public func submitData(name: String, timestamp: Date, author: String, email: String, institution: String, environment:String, parameters:String, details: String, attachment: String, offset: Int32) {

        // convert Date to timestamp String 
        let timestampString = Double(timestamp.timeIntervalSince1970)

        let entry = Entry(id: 1, name: name, timestamp: timestampString, author: author, email: email, institution: institution, environment: environment, parameters: parameters, details: details, attachment: attachment, hash: "", offset: offset)

        HyperClient.shared.insertData(data: entry)
    }
}
