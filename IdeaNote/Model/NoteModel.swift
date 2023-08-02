//
//  Model.swift
//  IdeaNote
//
//  Created by Dora on 2023/8/2.
//

import Foundation
import SwiftUI

struct NoteModel: Identifiable, Codable {
    var id = UUID()
    var writeTime: String
    var title: String
    var content: String
}
