//
//  EditAlbumView.swift
//  MCL
//
//  Created by Michel Andre Pellegrin Quiroz on 24/05/24.
//

import SwiftUI
import SwiftData

struct EditAlbumView: View {
    @Bindable var album: Album
    @StateObject private var songStore = SongStore()
    @State private var isShowingAddSongView = false
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @State private var refreshList = false
    
    @State private var titleAux: String = ""
    @State private var songAux: [SongFromCatalog] = []
    @State private var shortDescriptionAux: String = ""
    
    @State private var startDateAux: Date? = nil
    @State private var endDateAux: Date? = nil

    @State private var isDateEnabeled = false
    @State private var isEndDateEnabled = false
    
    var body: some View {
        NavigationStack {
            Form {
                /*--- ALBUM TITLE SECTION ---*/
                Section {
                    TextField("Name",
                              text: $titleAux,
                              prompt: Text("Album title")
                        .font(.system(size: 20))
                        .fontWeight(.bold))
                    .textInputAutocapitalization(.words)
                    .bold()
                    .multilineTextAlignment(.center)
                }
                .listSectionSpacing(.compact)
                
                /*--- ALBUM SONGS SECTION ---*/
                Section{
                    Button(action: {
                        self.isShowingAddSongView = true
                    }){
                        Label("Add Song",systemImage: "plus")
                    }
                    List{
                        ForEach($songAux) { $song in
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
    //                    .onDelete(perform: deleteSong(song))
                        AddedSongs(songStore: songStore)
                    }
                    
                } header: {
                    Text("Songs")
                        .font(.title2)
                        .bold()
                }
                .textCase(nil)
                
                /*--- ALBUM DESCRIPTION SECTION ---*/
                Section {
                    ZStack(alignment: .topLeading) {
                        if shortDescriptionAux.isEmpty {
                            Text("Enter album description...")
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                                .padding(.leading, 5)
                        }
                        TextEditor(text: $shortDescriptionAux)
                    }
                    .frame(height: 100)
                } header: {
                    Text("Album description")
                    //                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, -15)
                        .textCase(nil)
                }
                
                /*--- ALBUM DATE SECTION ---*/
                Section {
                    VStack {
                        Toggle("Add date", isOn: $isDateEnabeled)
                        if isDateEnabeled {
                            Divider()
                            if !isEndDateEnabled {
                                HStack {
                                    Text("Date:")
                                    DatePicker("", selection: Binding(
                                        get: { startDateAux ?? Date() },
                                        set: { startDateAux = $0 }
                                    ), displayedComponents: [.date])
                                }
                            } else {
                                VStack {
                                    HStack {
                                        Text("From:")
                                        DatePicker("", selection: Binding(
                                            get: { startDateAux ?? Date() },
                                            set: { startDateAux = $0 }
                                        ), displayedComponents: [.date])
                                    }
                                    HStack {
                                        Text("To:")
                                        DatePicker("", selection: Binding(
                                            get: { endDateAux ?? Date() },
                                            set: { endDateAux = $0 }
                                        ), displayedComponents: [.date])
                                    }
                                }
                            }
                            Divider()
                            Toggle("Enable range of dates", isOn: $isEndDateEnabled)
                        }
                    }
                }
                
            }// Close form
            
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
                        album.title = titleAux
                        album.songs = songAux + songStore.addedSongs
                        album.shortDescription = shortDescriptionAux
                        album.dateFrom = startDateAux
                        album.dateTo = endDateAux
                        dismiss()
                    }) {
                        Text("Save")
                            .fontWeight(.medium)
                    }
                    .disabled(album.title.isEmpty)
                }
            }
        }
        .onAppear {
            titleAux = album.title
            songAux = album.songs
            shortDescriptionAux = album.shortDescription
            startDateAux = album.dateFrom
            endDateAux = album.dateTo
            if startDateAux != nil && endDateAux != nil {
                isDateEnabeled = true
                isEndDateEnabled = true
            } else if startDateAux != nil && endDateAux == nil {
                isDateEnabeled = true
                isEndDateEnabled = false
            } else {
                isDateEnabeled = false
                isEndDateEnabled = false
            }
        }
        .sheet(isPresented: $isShowingAddSongView) {
            MusicSearchBar(songStore: songStore)
        }
    }
//    private func deleteSongs(indexSet: IndexSet) {
//        for index in indexSet {
//            context.delete(album.songs[index])
//            album.songs.remove(at: index)
//        }
//    }
    private func deleteSong(_ song: SongFromCatalog) {
        if let index = songAux.firstIndex(where: { $0.id == song.id }) {
            songAux.remove(at: index)
        }
    }
}

