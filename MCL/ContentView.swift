//
//  ContentView.swift
//  MCL
//
//  Created by Eduardo Gonzalez Melgoza on 14/05/24.
//

import SwiftUI
import SwiftData
import MusicKit


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State var songs = [SongFromCatalog]()
    @State private var searchString: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                MusicSearchBar()
            }
            .navigationTitle("Albums")
            .navigationBarTitleDisplayMode(.large)
            
        }
    }
}
