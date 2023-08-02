//
//  NewNoteView.swift
//  IdeaNote
//
//  Created by Dora on 2023/8/2.
//

import SwiftUI

struct NewNoteView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @State var noteModel: NoteModel
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Divider()
                titleView()
                Divider()
                contentView()
            }
            .navigationBarTitle("新建笔记", displayMode: .inline)
            .navigationBarItems(leading: closeBtnView(), trailing: saveBtnView())
            .toast(present: $viewModel.showToast, message: $viewModel.showToastMessage, alignment: .center)
        }
    }
    
    func closeBtnView() -> some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size:17))
                .foregroundColor(.gray)
        }
    }
    
    func saveBtnView() -> some View {
        Button(action: {
            if viewModel.isAdd {
                if viewModel.isTextEmpty(value: viewModel.title) {
                    viewModel.showToast = true
                    viewModel.showToastMessage = "请输入标题"
                } else if viewModel.isTextEmpty(value: viewModel.content) {
                    viewModel.showToast = true
                    viewModel.showToastMessage = "请输入内容"
                } else {
                    self.viewModel.addNote(writeTime: viewModel.getCurrentTime(), title: viewModel.title, content: viewModel.content)
                    self.presentationMode.wrappedValue.dismiss()
                }
            } else {
                if viewModel.isTextEmpty(value: noteModel.title) {
                    viewModel.showToast = true
                    viewModel.showToastMessage = "请输入标题"
                } else if viewModel.isTextEmpty(value: noteModel.content) {
                    viewModel.showToast = true
                    viewModel.showToastMessage = "请输入内容"
                } else {
                    self.viewModel.editItem(item: noteModel)
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }) {
            Text("完成")
                .font(.system(size: 17))
        }
    }
    
    func titleView() -> some View {
        TextField("请输入标题", text: viewModel.isAdd ? $viewModel.title : $noteModel.title)
            .padding()
    }
    
    func contentView() -> some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: viewModel.isAdd ? $viewModel.content : $noteModel.content)
                .font(.system(size: 17))
                .padding()
                
            if viewModel.isAdd ? (viewModel.content.isEmpty) : (noteModel.content.isEmpty) {
                Text("请输入内容")
                    .padding()
                    .foregroundColor(Color(UIColor.placeholderText))
            }
        }
    }
}


struct NewNoteView_Previews: PreviewProvider {
    static var previews: some View {
        NewNoteView(noteModel: NoteModel(writeTime: "", title: "", content: "")).environmentObject(ViewModel())
    }
}
