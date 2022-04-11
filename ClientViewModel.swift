//
//  ClientViewModel.swift
//  HyperClient
//
//  Created by Niko Ma on 3/29/22.
//

import SwiftUI

enum UploadOptions: Identifiable {
    case ipfs, cloud
    var id: Self { self }
}

class ClientViewModel: ObservableObject {
    @Published var showProgressView = false
    @Published var rawData: [ResponsePair]?
    @Published var pickedImage = [UIImage]()
    
    
    @Published var uploadOption:UploadOptions = .ipfs
    
    
    @MainActor
    public func fetchData() async {
        logger.info("Fetching data...")
        
        rawData = await HyperClient.shared.fetchData()
    }
    
    @MainActor
    public func submitData(name: String, timestamp: Date, author: String, email: String, institution: String,
                           environment:String, parameters:String, details: String, offset: Int32) async {
        // convert Date to timestamp String
        let timestampString = Double(timestamp.timeIntervalSince1970)
        var attachmentURL = ""
        
        func completion(url: String?) {
            if let url = url {
                attachmentURL += url
                attachmentURL += " "
                print("attachmentURL is \(attachmentURL)")
            }
        }
        if pickedImage.count > 0 {
            switch uploadOption {
            case .ipfs:
                for image in pickedImage {
                    await HyperClient.shared.uploadIPFS(data: image.jpegData(compressionQuality: 1)!, completion: completion)
                }
            case .cloud:
                for image in pickedImage {
                    await HyperClient.shared.uploadCloud(data: image.jpegData(compressionQuality: 1)!, completion: completion)
                }
            }
            pickedImage.removeAll()
        }
        
        let entry = Entry(id: 1, name: name, timestamp: timestampString, author: author, email: email, institution: institution, environment: environment, parameters: parameters, details: details, attachment: attachmentURL, hash: "", offset: offset)
        
        HyperClient.shared.insertData(data: entry)
    }
    
    
}
