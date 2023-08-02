//
//  ViewModel.swift
//  IdeaNote
//
//  Created by Dora on 2023/8/2.
//

import Combine
import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    @Published var noteModels = [NoteModel]()
    
    
    // 笔记参数
    @Published var writeTime: String = ""
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var searchText: String = ""
    
    @Published var isSearching: Bool = false
    
    @Published var isAdd: Bool = true
    
    @Published var showNewNoteView: Bool = false
    @Published var showEditNoteView: Bool = false
    
    @Published var showActionSheet: Bool = false
    
    @Published var showToast = false
    @Published var showToastMessage: String = "提示信息"
    
    init () {
        loadItems()
        saveItems()
    }
    
    func documentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func dataFilePath() -> URL {
        documentsDirectory().appendingPathComponent("IdeaNote.plist")
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(noteModels)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error writing items to file: (error.localizedDescription)")
        }
    }
    
    func loadItems() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                noteModels = try decoder.decode([NoteModel].self, from: data)
            } catch {
                print("Error reading items: (error.localizedDescription)")
            }
        }
    }
    
    func addNote(writeTime: String, title: String, content: String) {
        let newItem = NoteModel(writeTime: writeTime, title: title, content: content)
        noteModels.append(newItem)
        saveItems()
    }
    
    func getItemById(itemId: UUID) -> NoteModel? {
        return noteModels.first(where: { $0.id == itemId }) ?? nil
    }
    
    func deleteItem(itemId: UUID) {
        noteModels.removeAll(where: {$0.id == itemId})
        saveItems()
    }
    
    func editItem(item: NoteModel) {
        if let id = noteModels.firstIndex(where: {$0.id == item.id}) {
            noteModels[id] = item
            saveItems()
        }
    }
    
    func searchContent() {
        let query = searchText.lowercased()
        DispatchQueue.global(qos: .background).async {
            let filter = self.noteModels.filter { $0.content.lowercased().contains(query) }
            DispatchQueue.main.async {
                self.noteModels = filter
            }
        }
    }
    
    func getCurrentTime() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY.MM.dd"
        return dateformatter.string(from: Date())
    }
    
    func isTextEmpty(value: String) -> Bool {
        if value == "" {
            return true
        }
        return false
    }
}
