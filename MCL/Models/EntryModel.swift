//
//  EntryModel.swift
//  MCL
//
//  Created by Eduardo Gonzalez Melgoza on 27/05/24.
//

import Foundation
import SwiftData

@Model
final class Entry {
    var entryText: String = ""
    var prompt: String?
    var dateCreated: Date
    
    init(entryText: String, prompt: String? = nil, dateCreated: Date) {
        self.entryText = entryText
        self.prompt = prompt
        self.dateCreated = dateCreated
    }
}
