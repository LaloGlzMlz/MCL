//
//  BookletView.swift
//  MCL
//
//  Created by Michel Andre Pellegrin Quiroz on 21/05/24.
//

import SwiftUI
import SwiftData

struct BookletView: View {
    @Environment(\.modelContext) private var context
    
    let album: Album
    
    @State private var songsFromAlbum: [SongStore] = []
    
    var body: some View {
        NavigationStack{
                ForEach(album.songs){ song in
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
            .navigationTitle(album.title)
        }
    }
}

