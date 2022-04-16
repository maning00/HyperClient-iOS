//
//  HistoryView.swift
//  HyperClient (iOS)
//
//  Created by Niko Ma on 4/16/22.
//

import SwiftUI

struct HistoryView: View {
    @State var dataPair: ResponsePair
    
    var body: some View {
        List {
            Group {
                Section("实验名称") {
                    Text(dataPair.data.name)
                }
                Section("实验时间") {
                    Text(dataPair.data.experiment_time.toDate)
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
                    ForEach(dataPair.data.attachment.components(separatedBy: " "), id: \.self) { str in
                        Text(str).onTapGesture {
                            UIApplication.shared.open(URL(string: str.trimmingCharacters(in: .whitespacesAndNewlines))!)
                        }.foregroundColor(.accentColor)
                    }
                }
            }
            Group {
                Section("数据哈希值") {
                    Text(dataPair.data.hash)
                }
                
                Section("数据验证结果") {
                    dataPair.authentication.result == true ? Image(systemName: "checkmark.circle").font(.system(size: 40)).foregroundColor(.green) : Image(systemName: "xmark.circle").font(.system(size: 40)).foregroundColor(.red)
                }
                Section("提交时间") {
                    Text(Date(timeIntervalSince1970: dataPair.data.timestamp).description(with: .current))
                }
            }
        }
    }
}
