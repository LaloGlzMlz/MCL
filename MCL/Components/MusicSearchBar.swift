//
//  MusicSearchBar.swift
//  MCL
//
//  Created by Eduardo Gonzalez Melgoza on 15/05/24.
//

import SwiftUI
import SwiftData
import MusicKit
import SimpleToast


struct MusicSearchBar: View {
    @Environment(\.modelContext) private var modelContext
    @State var songs = [SongFromCatalog]()
    @ObservedObject var songStore: SongStore
    @State private var showToast = false
    @State private var value = 0
    @State private var showAlertAlreadyAdded = false
    @State private var showAlertLimitSongs = false
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var searchString = DebouncedState(initialValue: "", delay: 0.3)
    
    
    var toastOptions = SimpleToastOptions(
        alignment: .bottom,
        hideAfter: 2,
        backdrop: Color.black.opacity(0),
        animation: .default,
        modifierType: .slide
        
    )
    
    var body: some View {
        NavigationStack{
            Section {
                List(songs) { song in
                    HStack {
                        HStack {
                            AsyncImage(url: song.imageURL)
                                .frame(width: 40, height: 40, alignment: .leading)
                            VStack (alignment: .leading) {
                                Text(song.name)
                                    .fontWeight(.medium)
                                    .lineLimit(1)
                                Text(song.artist)
                                    .font(.footnote)
    //                                .fontWeight(.light)
                            }
                        }
                        Spacer()
                        Button(action: {
                            addSong(song)
                        }){
                            Image(systemName: "plus.circle")
                                .foregroundStyle(Color.green)
                        }
                        
                    }
                    .swipeActions(edge: .trailing) {
                        Button(){
                            addSong(song)
                        } label: {
                            Label("Add", systemImage: "plus")
                        }
                        .tint(.green)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .searchable(text: $searchString.currentValue, prompt: "Search songs")
            .onChange(of: searchString.debouncedValue) { oldValue, newValue in
                fetchMusic()
                print(newValue)
                print(oldValue)
            }
            .onAppear {
                fetchMusic()
            }
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
                        dismiss()
                    }) {
                        Text("Done")
                            .fontWeight(.medium)
                    }
                    .disabled(songStore.addedSongs.isEmpty)
                }
            }
        }
        .alert(isPresented: $showAlertAlreadyAdded) {
            Alert(title: Text("This song is already in your album."), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $showAlertLimitSongs) {
            Alert(title: Text("Albums can contain a maximum of 20 songs."), dismissButton: .default(Text("OK")))
        }
        .simpleToast(isPresented: $showToast, options: toastOptions, onDismiss: {
            value += 1
        }){
            HStack{
                Image(systemName: "checkmark")
                Text("Song added")
                    .bold()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14.0))
            .shadow(radius: 10)
            
        }
    }
    
    private var request: MusicCatalogSearchRequest {
        var request = MusicCatalogSearchRequest(term: searchString.currentValue, types: [Song.self])
        request.limit = 15
        return request
    }
    
    
    private func fetchMusic() {
        Task {
            let status = await MusicAuthorization.request()
            switch status {
            case .authorized:
                do {
                    let result = try await request.response()
                    self.songs = result.songs.compactMap({
                        return .init(name: $0.title,
                                     artist: $0.artistName,
                                     imageURL: $0.artwork?.url(width: 40, height: 40))
                    })
                } catch {
                    print(String(describing: error))
                }
                break
            default:
                break
            }
        }
    }
    private func addSong(_ song: SongFromCatalog) {
        if songStore.addedSongs.contains(where: { $0.name == song.name && $0.artist == song.artist }){
            showAlertAlreadyAdded = true
        } else if songStore.addedSongs.count >= 20 {
            showAlertLimitSongs = true
        } else {
            songStore.addedSongs.append(song)
            showToast.toggle()
        }
        
    }
}
