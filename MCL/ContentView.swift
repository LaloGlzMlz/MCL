//
//  ContentView.swift
//  Flamingo
//
//  Created by Fernando Sensenhauser on 13/05/24.
//

import SwiftUI
import SwiftData
import MusicKit


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State var songs = [SongFromCatalog]()
    @State private var searchString: String = ""
    
    var body: some View {
        NavigationStack {
            FirstScreenView()
//                .navigationTitle("Albums")
//                .navigationBarTitleDisplayMode(.large)
        }
    }
}
