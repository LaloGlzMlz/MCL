//
//  AddedSongs.swift
//  MCL
//
//  Created by Michel Andre Pellegrin Quiroz on 18/05/24.
//

import SwiftUI

struct AddedSongs: View {
    @ObservedObject var songStore: SongStore
        
        var body: some View {
            NavigationStack {
                List(songStore.addedSongs) { song in
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
                }
            }
        }
    }

