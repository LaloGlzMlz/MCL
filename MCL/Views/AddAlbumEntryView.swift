//
//  AddAlbumEntryView.swift
//  MCL
//
//  Created by Eduardo Gonzalez Melgoza on 27/05/24.
//

import SwiftUI
import SwiftData

struct AddAlbumEntryView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    @State private var entryText = ""
    
    @State private var showingPrompt = false
    @State private var prompt: String = ""
    
    @StateObject private var promptsViewModel = PromptsViewModel()
    
    @Bindable var album: Album
    
    var body: some View {
        NavigationStack {
            VStack {
                if showingPrompt {
                    Text(prompt)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                        .padding([.top, .leading, .trailing])
                }
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $entryText)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Button(action: {
                                    showingPrompt.toggle()
                                    if showingPrompt {
                                        prompt = promptsViewModel.getRandomPrompt()
                                    }
                                }) {
                                    Image(systemName: "lightbulb.max.fill")
                                }
                            }
                        }
                    
                    if entryText.isEmpty {
                        Text("Write about your album \(album.title)...")
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                            .padding(.leading, 5)
                            .allowsHitTesting(false)
                    }
                }
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
                        if !showingPrompt {
                            prompt = ""
                        }
                        let entry = Entry(
                            entryText: entryText,
                            prompt: prompt,
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
