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
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @State private var refreshList = false
    
    @State private var titleAux: String = ""
    @State private var songAux: [SongFromCatalog] = []
    
    
    var body: some View {
        NavigationStack {
            TextField("Name",
                      text: $titleAux,
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
                    ForEach($songAux) { $song in
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
                    }
                    .onDelete(perform: deleteSongs)
                    AddedSongs(songStore: songStore)
                }
            }
            .listSectionSpacing(.compact)
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
                        album.title = titleAux
                        album.songs = songAux + songStore.addedSongs
//                        print("\(songStore.addedSongs)")
//                        for songStore in songStore.addedSongs {
//                            print(songStore.name)
//                        }
                        dismiss()
                    }) {
                        Text("Save")
                            .fontWeight(.medium)
                    }
                    .disabled(album.title.isEmpty)
                }
            }
        }
        .onAppear {
            titleAux = album.title
            songAux = album.songs
        }
        .sheet(isPresented: $isShowingAddSongView) {
            MusicSearchBar(songStore: songStore)
        }
    }
    private func deleteSongs(indexSet: IndexSet) {
        for index in indexSet {
            context.delete(album.songs[index])
            album.songs.remove(at: index)
        }
    }
}

