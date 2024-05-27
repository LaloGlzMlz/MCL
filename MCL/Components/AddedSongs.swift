//
//  AddedSongs.swift
//  MCL
//
//  Created by Michel Andre Pellegrin Quiroz on 18/05/24.
//

import SwiftUI
import SimpleToast

// When calling the AddedSongs component and the music search bar component,
// add the following line first
//    @StateObject private var songStore = SongStore()

struct AddedSongs: View {
    @ObservedObject var songStore: SongStore
    var body: some View {
        ForEach(songStore.addedSongs) { song in
            HStack{
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
                Spacer()
                Button(action: {
                    deleteSong(song)
                }){
                    Image(systemName: "minus.circle")
                        .foregroundStyle(Color.red)
                }
            }
            .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                    deleteSong(song)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }
    
    private func deleteSong(_ song: SongFromCatalog) {
        if let index = songStore.addedSongs.firstIndex(where: { $0.id == song.id }) {
            songStore.addedSongs.remove(at: index)
        }
    }
}

