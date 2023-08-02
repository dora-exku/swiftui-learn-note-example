//
//  ContentView.swift
//  IdeaNote
//
//  Created by Dora on 2023/8/2.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.noteModels.count == 0 {
                    noDataView()
                } else {
                    VStack {
                        searchBarView()
                        noteListView()
                    }
                }
                newBtnView()
            }
//            .padding(12)
            .navigationBarTitle("念头笔记", displayMode: .inline)
        }.sheet(isPresented: $viewModel.showNewNoteView, content: {
            NewNoteView(noteModel: NoteModel(writeTime: "", title: "", content: ""))
        })
    }
    
    func noteListView() -> some  View {
        List {
            ForEach(viewModel.noteModels) { noteItem in
                NoteListRow(itemId: noteItem.id)
            }
        }
        .listStyle(InsetListStyle())
    }
    
    // 缺省图
    func noDataView() -> some View {
        VStack(alignment: .center, spacing: 40) {
            Image("nodataimage")
                .resizable()
                .scaledToFit()
                .frame(width:240)
            
            Text("记录下这个世界的点滴")
                .font(.system(size:16))
                .bold()
                .foregroundColor(.gray)
        }
    }
    
    // 新建按钮
    func newBtnView() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    self.viewModel.isAdd = true
                    self.viewModel.writeTime = viewModel.getCurrentTime()
                    self.viewModel.title = ""
                    self.viewModel.content = ""
                    self.viewModel.showNewNoteView = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(.bottom, 32)
        .padding(.trailing, 32)
    }
    
    // 搜索框
    func searchBarView() -> some View {
        TextField("搜索内容", text: $viewModel.searchText)
            .padding(7)
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                    
                    if viewModel.searchText != "" {
                        Button(action: {
                            self.viewModel.searchText = ""
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        }
                    }
                }
            )
            .padding(.horizontal, 10)
            .onChange(of: viewModel.searchText) { _ in
                if viewModel.searchText != "" {
                    self.viewModel.isSearching = true
                    self.viewModel.searchContent()
                } else {
                    viewModel.searchText = ""
                    self.viewModel.isSearching = false
                    self.viewModel.loadItems()
                }
            }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ViewModel())
    }
}

struct NoteListRow : View {
    @EnvironmentObject var viewModel: ViewModel
    
    var itemId: UUID
    
    var item: NoteModel? {
        return viewModel.getItemById(itemId: itemId)
    }
    
    var body: some View {
        HStack {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(item?.writeTime ?? "")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Text(item?.title ?? "")
                        .font(.system(size: 17))
                        .foregroundColor(.black)
                        .bold()
                    Text(item?.content ?? "")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                }
            }
            .onTapGesture {
                self.viewModel.isAdd = false
                self.viewModel.showEditNoteView = true
            }
            Spacer()
            
            Button(action: {
                viewModel.showActionSheet = true
            }) {
                Image(systemName: "ellipsis")
                    .foregroundColor(.gray)
                    .font(.system(size: 23))
            }
        }
        .sheet(isPresented: $viewModel.showEditNoteView) {
            NewNoteView(noteModel: self.item ?? NoteModel(writeTime: "", title: "", content: ""))
        }
        .actionSheet(isPresented: self.$viewModel.showActionSheet, content: {
            ActionSheet(
                title: Text("你确定要删除此项吗?"),
                message: nil,
                buttons: [
                    .destructive(Text("删除"), action: {
                        self.viewModel.deleteItem(itemId: itemId)
                    }),
                    .cancel(Text("取消"))
                ]
            )
        })
    }
}
