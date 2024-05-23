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
    @State private var isShowingEditView = false
    @StateObject private var songStore = SongStore()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    AlbumCard(album: album)
                        .shadow(radius: 20)
                    
                    VStack(alignment: .leading) {
//                        Text(album.title)
//                            .font(.title)
//                            .bold()
                        
                        // Description
                        Text("Placeholder for description about the album")
                            .font(.subheadline)
                        
                        ForEach(album.songs) { song in
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(.white)
                                    .shadow(color: Color.black.opacity(0.15), radius: 20)
                                    .frame(width: UIScreen.main.bounds.width/1.1, height: UIScreen.main.bounds.height/12)
                                
                                HStack {
                                    AsyncImage(url: song.imageURL)
                                        .frame(width: 40, height: 40, alignment: .leading)
                                        .padding()
                                    
                                    VStack(alignment: .leading) {
                                        Text(song.name)
                                            .fontWeight(.medium)
                                            .lineLimit(1)
                                        
                                        Text(song.artist)
                                            .font(.footnote)
                                    }
                                }
                                .frame(width: UIScreen.main.bounds.width/1.1, height: UIScreen.main.bounds.height/11, alignment: .leading)
                            }
                        }
                    }
                }
                .padding(.horizontal) // Add horizontal padding to the ScrollView content to prevent clipping by ScrollView
            }
            .navigationTitle(album.title)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {
                        // Here action
                    }) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {
                        // Here action
                    }) {
                        Label("Options", systemImage: "ellipsis")
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingEditView) {
            AddAlbumView()
            
        }
    }
}
