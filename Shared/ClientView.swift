//
//  ContentView.swift
//  Shared
//
//  Created by Niko Ma on 3/25/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authentication: Authentication
    @ObservedObject var document: ClientViewModel
    @State var showSubmitForm: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                
                List {
                    Section {
                        VStack {
                            Text("🙋🏻‍♀️").font(.system(size: 80)).frame(width:300, height: 90)
                            Text("欢迎你，\(authentication.credentials.username)").font(.title).fontWeight(.bold).multilineTextAlignment(.center).frame(width:300, height: 50)
                        }
                    }
                    Section{
                        Text("增加数据").foregroundColor(.accentColor).frame(width: 300, height: 30, alignment: .leading).contentShape(Rectangle()).onTapGesture {
                            showSubmitForm = true
                        }
                    }
                    
                    Section("实验数据列表") {
                        if let rawData = document.rawData {
                            ForEach(rawData, id:\.self) { pair in
                                NavigationLink {
                                    DataDetail(dataPair: pair)
                                } label: {
                                    Text(pair.data.name)
                                }
                                
                            }
                        }
                    }
                }
            }.navigationTitle(Text("HyperClient"))
                .task { await document.fetchData() }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("注销") {
                            authentication.updateValidation(success: false)
                        }
                    }
                }
                .popover(isPresented: $showSubmitForm) {
                    CreateEntryView(clientVM: document)
                }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: ClientViewModel())
            .previewDevice("iPhone 13 Pro").environmentObject(Authentication())
    }
}
