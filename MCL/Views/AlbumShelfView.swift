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
    @State private var showingAddAlbumSheet: Bool = false
    
    @State private var path: [Album] = []
    @State private var newAlbum: Album?
    
    @Query(sort: \Album.dateOfAlbum, order: .reverse) var albums: [Album]
    
    var body: some View {
//        NavigationStack(path: $path) {
        NavigationStack {
            VStack {
                List {
                    ForEach(albums) { album in
                        NavigationLink(destination: BookletView(album: album)){
                            VStack {
                                Text(album.title)
                            }
                        }
                        
                        .swipeActions {
                            Button("Delete", role: .destructive) {
                                context.delete(album)
                            }
                        }
                    }
                }
                Shelf()
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
//            .sheet(isPresented: $showingAddAlbumSheet, onDismiss: {
//                if let album = newAlbum {
//                    path.append(album)
//                    newAlbum = nil // Reset after navigation
//                }
//            }) {
//                AddAlbumView(newAlbum: $newAlbum)
//            }
//            .navigationDestination(for: Album.self) { album in
//                BookletView(album: album)
//            }
        }
    }
}

//#Preview {
//    AlbumShelfView()
//}
