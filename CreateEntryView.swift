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
    
    @State private var imagePicker: ImagePickerType? = nil
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
    
    @FocusState private var focusedField: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section("实验名称") {
                    TextField("实验名称", text: $name).focused($focusedField)
                }
                Section("实验时间") {
                    DatePicker("实验时间", selection: $time)
                }
                Section("作者") {
                    TextField("作者", text: $author).focused($focusedField)
                }
                Section("电子邮件") {
                    TextField("电子邮件", text: $email).focused($focusedField)
                }
                Section("机构") {
                    TextField("机构", text: $institution).focused($focusedField)
                }
                Section("实验环境") {
                    TextField("实验环境", text: $environment).focused($focusedField)
                }
                Section("实验参数") {
                    TextField("实验参数", text: $parameters).focused($focusedField)
                }
                Section("实验详细信息") {
                    TextField("实验详细信息", text: $details).focused($focusedField)
                }
                Section("附件") {
                    Picker("存储位置", selection: $clientVM.uploadOption) {
                        HStack {
                            Image("ipfs-logo").resizable().frame(width: 30, height: 30)
                            Text("IPFS")
                        }.tag(UploadOptions.ipfs)
                        HStack {
                            Image("nextcloud-logo").resizable().frame(width: 30, height: 25)
                            Text("NextCloud")
                        }.tag(UploadOptions.cloud)
                    }
                    attachmentSection
                }
            }.navigationTitle("提交数据")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("提交") {
                            Task {
                                await clientVM.submitData(name: name, experimentTime: time, author: author, email: email, institution: institution, environment: environment, parameters: parameters, details: details, offset: offset)
                                await clientVM.fetchData()
                            }
                            dissmiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("取消") {
                            Task {
                                await clientVM.fetchData()
                            }
                            dissmiss()
                        }
                    }
                    ToolbarItem(placement: .keyboard) {
                        Button("完成") {
                            focusedField = false
                        }
                    }
                }
            
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func handlePickedImage(_ image: UIImage?) {
        logger.info("Function handlePickedImage catched image")
        if let image = image {
            clientVM.pickedImage.append(image)
        }
        imagePicker = nil
    }
    
    var imagePickerMenu: some View {
        Menu {
            Button {
                withAnimation {
                    imagePicker = .camera
                }
            } label: {
                Label("相机", systemImage: "camera")
            }
            Button {
                withAnimation {
                    imagePicker = .library
                }
            } label: {
                Label("相簿", systemImage: "photo.on.rectangle")
            }
        } label: {
            Label("", systemImage: "plus.circle").font(.system(size: 45))
        }
    }
    
    var attachmentSection: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
            imagePickerMenu
            ForEach(clientVM.pickedImage, id: \.self) { data in
                Image(uiImage: data)
                    .resizable()
                    .frame(maxWidth: 80, maxHeight: 80)
            }
        }.sheet(item: $imagePicker) { pickerType in
            switch pickerType {
            case .camera:
                Camera(imageHandleFunc: handlePickedImage)
            case .library:
                ImagePicker(imageHandleFunc: handlePickedImage)
            }
        }
    }
}

struct CreateEntryView_Previews: PreviewProvider {
    static var previews: some View {
        CreateEntryView(clientVM: ClientViewModel(), offset: -1)
    }
}
