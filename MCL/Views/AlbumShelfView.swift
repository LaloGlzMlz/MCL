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
    
    @Query(sort: \Album.title) var albums: [Album]
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(albums) { album in
                        Text(album.title)
                            .swipeActions {
                                Button("Delete", role: .destructive) {
                                    context.delete(album)
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
                .sheet(isPresented: $showingAddAlbumSheet) { AddAlbumSheetView() }
            }
        }
    }
}

//#Preview {
//    AlbumShelfView()
//}
