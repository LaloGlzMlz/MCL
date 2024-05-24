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
//    @Bindable var song: SongFromCatalog
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
                    ForEach($album.songs) { $song in
                        HStack{
                            AsyncImage(url: song.imageURL)
                                .frame(width: 40, height: 40, alignment: .leading)
                            VStack(alignment: .leading) {
                                Text(song.name)
                                    .fontWeight(.medium)
                                    .lineLimit(1)
                                Text(song.artist)
                                    .font(.footnote)
                                    .fontWeight(.light)
                            }
                        }
//                        .swipeActions(edge: .trailing) {
//                            Button(role: .destructive) {
//                                deleteSong(song)
//                            } label: {
//                                Label("Delete", systemImage: "trash")
//                            }
//                        }
                    }
                }
            }
            .listSectionSpacing(.compact)
        }
//        .sheet(isPresented: $isShowingAddSongView) {
//            MusicSearchBar(songStore: songStore)
//        }
    }
}

