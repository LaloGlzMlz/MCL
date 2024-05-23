//
//  AlbumShelfView.swift
//
//  Created by Fernando Sensenhauser on 13/05/24.
//

import SwiftUI
import SwiftData

struct AlbumShelfView: View {
    @Environment(\.modelContext) private var context
    
    @State var albumTitle: String = ""
    @State var name: String?
    @State private var showingAddAlbumSheet = false
    
    @State var offsetToCenter = UIScreen.main.bounds.width/8
    
    @Query(sort: \Album.dateOfAlbum, order: .reverse) var albums: [Album]
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 2) {
                        ForEach(albums) { album in
                            NavigationLink(destination: BookletView(album: album)){
                                VStack {
                                    AlbumCard(album: album)
                                        .shadow(color: Color.black.opacity(0.15), radius: 20)
                                        .padding()
                                        .contextMenu(ContextMenu(menuItems: {
                                            Button("Delete", role: .destructive) {
                                                context.delete(album)
                                            }
                                        }))
                                }
                            }
                        }
                    }
                    .padding()
                }
                .offset(y: -offsetToCenter)
                .overlay {
                    if albums.isEmpty {
                        ContentUnavailableView(label: {
                            Label("No albums have been created", systemImage: "opticaldisc.fill")
                        }, description: {
                            Text("Create an album to see it in your shelf")
                        }, actions: {
                            Button("Create album") { showingAddAlbumSheet = true }
                        })
                        .offset(y: -offsetToCenter)
                    }
                }
            }
            .navigationTitle("Albums")
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button(action: {
                        showingAddAlbumSheet = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.blue) // Adjust color if needed
                    }
                }
            }
            .sheet(isPresented: $showingAddAlbumSheet) { AddAlbumView() }
        }
    }
}

//#Preview {
//    AlbumShelfView()
//}
