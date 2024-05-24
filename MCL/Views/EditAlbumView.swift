//
//  EditAlbumView.swift
//  MCL
//
//  Created by Michel Andre Pellegrin Quiroz on 24/05/24.
//

import SwiftUI
import SwiftData

struct EditAlbumView: View {
    @Bindable var album: Album
    @StateObject private var songStore = SongStore()
    @State private var isShowingAddSongView = false
    
    var body: some View {
        NavigationStack{
            TextField("Name",
                      text: $album.title,
                      prompt: Text("Album title")
                .font(.system(size: 20))
                .fontWeight(.bold))
            .textInputAutocapitalization(.words)
            .bold()
            .multilineTextAlignment(.center)
            .padding(15)
            Divider()
            Section{
                Button(action: {
                    self.isShowingAddSongView = true
                }){
                    Label("Add Song",systemImage: "plus")
                }
                
            } header: {
                Text("Songs")
                    .font(.title2)
                    .bold()
            }
            .textCase(nil)
            Section {
                List{
                    AddedSongs(songStore: songStore)
                }
            }
            .listSectionSpacing(.compact)
        }
        .sheet(isPresented: $isShowingAddSongView) {
            MusicSearchBar(songStore: songStore)
        }
    }
}

