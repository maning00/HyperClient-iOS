//
//  DataDetailView.swift
//  HyperClient (iOS)
//
//  Created by Niko Ma on 3/30/22.
//

import SwiftUI

struct DataDetail: View {
    var dataPair: ResponsePair
    
    var body: some View {
            List {
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
                Section("数据哈希值") {
                    Text(dataPair.data.hash)
                }
        }
    }
}

