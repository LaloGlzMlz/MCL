//
//  FirstScreenView.swift
//
//  Created by Fernando Sensenhauser on 13/05/24.
//

import SwiftUI

struct FirstScreenView: View {
    @State var albumTitle: String = ""
    @State var name: String?
    @State private var showingAddAlbumSheet = false
    
    var body: some View {
        NavigationStack {
            VStack {
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
            .sheet(isPresented: $showingAddAlbumSheet) { NewAlbumFormView() }
        }
    }
}

#Preview {
    FirstScreenView()
}
