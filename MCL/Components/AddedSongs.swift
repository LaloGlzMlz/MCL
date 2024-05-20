//
//  AddedSongs.swift
//  MCL
//
//  Created by Michel Andre Pellegrin Quiroz on 18/05/24.
//

import SwiftUI
import SimpleToast

struct AddedSongs: View {
    @ObservedObject var songStore: SongStore
    @State private var showToast = false
    @State private var value = 0
    
    var toastOptions = SimpleToastOptions(
        alignment: .bottom,
        hideAfter: 2,
        backdrop: Color.black.opacity(0),
        animation: .default,
        modifierType: .slide
        
    )
    var body: some View {
        NavigationStack {
            List{
                ForEach(songStore.addedSongs) { song in
                    HStack {
                        AsyncImage(url: song.imageURL)
                            .frame(width: 40, height: 40, alignment: .leading)
                        VStack(alignment: .leading) {
                            Text(song.name)
                                .fontWeight(.medium)
                            Text(song.artist)
                                .font(.footnote)
                                .fontWeight(.light)
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            deleteSong(song)
                            showToast.toggle()
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
        }
        .simpleToast(isPresented: $showToast, options: toastOptions, onDismiss: {
            value += 1
        }){
            HStack{
                Image(systemName: "minus")
                Text("Song deleted")
                    .bold()
            }
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14.0))
            .shadow(radius: 10)
            
        }
    }
    
    private func deleteSong(_ song: SongFromCatalog) {
        if let index = songStore.addedSongs.firstIndex(where: { $0.id == song.id }) {
            songStore.addedSongs.remove(at: index)
        }
    }
}

