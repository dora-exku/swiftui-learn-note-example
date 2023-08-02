//
//  IdeaNoteApp.swift
//  IdeaNote
//
//  Created by Dora on 2023/8/2.
//

import SwiftUI

@main
struct IdeaNoteApp: App {
    
    @StateObject var viewModel: ViewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
