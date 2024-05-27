//
//  AddEntryView.swift
//  MCL
//
//  Created by Eduardo Gonzalez Melgoza on 27/05/24.
//

import SwiftUI
import SwiftData

struct AddEntryView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    @State private var entryText = ""
    
    @Bindable var album: Album
    
    var body: some View {
        NavigationStack {
            VStack {
                TextEditor(text: $entryText)
                    .padding()
            }
            .navigationTitle("New entry")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancel")
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {
                        let entry = Entry(
                            entryText: entryText,
                            dateCreated: Date()
                        )
                        album.entries.append(entry)
                        dismiss()
                    }) {
                        Text("Add")
                            .fontWeight(.medium)
                    }
                }
            }
        }
    }
}
