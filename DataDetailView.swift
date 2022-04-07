//
//  DataDetailView.swift
//  HyperClient (iOS)
//
//  Created by Niko Ma on 3/30/22.
//

import SwiftUI

struct DataDetail: View {
    @State var dataPair: ResponsePair
    @State var showEditor = false
    @Environment(\.dismiss) var dissmiss
    @EnvironmentObject var clientVM: ClientViewModel
    
    var body: some View {
        List {
            Group {
                Section("实验名称") {
                    Text(dataPair.data.name)
                }
                Section("实验时间") {
                    Text(Date(timeIntervalSince1970: dataPair.data.timestamp).description(with: .current))
                }
                Section("作者") {
                    Text(dataPair.data.author)
                }
                Section("电子邮件") {
                    Text(dataPair.data.email)
                }
                Section("机构") {
                    Text(dataPair.data.institution)
                }
                Section("实验环境") {
                    Text(dataPair.data.environment)
                }
                Section("实验参数") {
                    Text(dataPair.data.parameters)
                }
                Section("详细信息") {
                    Text(dataPair.data.details)
                }
                Section("附件") {
                    Text(dataPair.data.attachment)
                }
            }
            Group {
                Section("数据哈希值") {
                    Text(dataPair.data.hash)
                }
                
                Section("数据验证结果") {
                    dataPair.authentication.result == true ? Image(systemName: "checkmark.circle").font(.system(size: 40)).foregroundColor(.green) : Image(systemName: "xmark.circle").font(.system(size: 40)).foregroundColor(.red)
                }
            }
        }.toolbar {
            ToolbarItem {
                Button("编辑") {
                    showEditor = true
                }
            }
        }.task {
            dataPair.verify()
        }
        .popover(isPresented: $showEditor) {
            CreateEntryView(clientVM: clientVM, name: dataPair.data.name, time: Date(timeIntervalSince1970: dataPair.data.timestamp), author: dataPair.data.author, email: dataPair.data.email, institution: dataPair.data.institution, environment: dataPair.data.environment, parameters: dataPair.data.parameters, details: dataPair.data.details, attachment: dataPair.data.attachment, offset: dataPair.data.offset)
        }
    }
}

