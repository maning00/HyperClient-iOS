//
//  CreateEntryView.swift
//  HyperClient
//
//  Created by Niko Ma on 3/31/22.
//

import SwiftUI

struct CreateEntryView: View {
    @ObservedObject var clientVM: ClientViewModel
    @Environment(\.dismiss) var dissmiss
    
    @State var name: String = ""
    @State var time = Date.now
    @State var author: String = ""
    @State var email: String = ""
    @State var institution: String = ""
    @State var environment: String = ""
    @State var parameters: String = ""
    @State var details: String = ""
    @State var attachment: String = ""
    @State var offset: Int32
    
    var body: some View {
        NavigationView {
            Form {
                Section("实验名称") {
                    TextField("实验名称", text: $name)
                }
                Section("实验时间") {
                    DatePicker("实验时间", selection: $time)
                }
                Section("作者") {
                    TextField("作者", text: $author)
                }
                Section("电子邮件") {
                    TextField("电子邮件", text: $email)
                }
                Section("机构") {
                    TextField("机构", text: $institution)
                }
                Section("实验环境") {
                    TextField("实验环境", text: $environment)
                }
                Section("实验参数") {
                    TextField("实验参数", text: $parameters)
                }
                Section("实验详细信息") {
                    TextField("实验详细信息", text: $details)
                }
                Section("附件") {
                    TextField("附件", text: $attachment)
                }
            }.navigationTitle("提交数据")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("提交") {
                            clientVM.submitData(name: name, timestamp: time, author: author, email: email, institution: institution, environment: environment, parameters: parameters, details: details, attachment: attachment, offset: offset)
                            dissmiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("取消") {
                            dissmiss()
                        }
                    }
                }
                
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct CreateEntryView_Previews: PreviewProvider {
    static var previews: some View {
        CreateEntryView(clientVM: ClientViewModel(), offset: -1)
    }
}
