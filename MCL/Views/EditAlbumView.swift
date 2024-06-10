//
//  EditAlbumView.swift
//  MCL
//
//  Created by Michel Andre Pellegrin Quiroz on 24/05/24.
//

import SwiftUI
import SwiftData
import PhotosUI

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
    
    @State private var startDateAux: Date? = Date(){
        didSet {
            if let end = endDateAux, let start = startDateAux {
                if end < start {
                    endDateAux = start
                }
            }
        }
    }
    @State private var endDateAux: Date? = Date(){
        didSet {
            if let end = endDateAux, let start = startDateAux {
                if end < start {
                    startDateAux = end
                }
            }
        }
    }
    
    @State private var isDateEnabeled = false
    @State private var isEndDateEnabled = false
    
    @State var selectedPhoto: PhotosPickerItem?
    @State var selectedPhotoDataAux: Data?
    @State var sideMeasure = UIScreen.main.bounds.width / 1.5
    
    @StateObject var locationManager: SearchLocation = .init()
    @State private var isShowingLocationSheet = false
    @State private var isLocationEnabeled = false
    @State private var chosenLocation: String = ""
    
    @FocusState private var nameIsFocused: Bool
    
    @State private var showAlertAlreadyAdded = false
    
    var body: some View {
        NavigationStack {
            Form {
                /*--- ALBUM COVER SECTION ---*/
                Section {
                    VStack {
                        HStack {
                            Spacer()
                            if selectedPhotoDataAux == nil {
                                PhotosPicker(selection: $selectedPhoto,
                                             matching: .images,
                                             photoLibrary: .shared()) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 5.0)
                                            .frame(width: sideMeasure, height: sideMeasure)
                                            .foregroundStyle(Color.gray)
                                            .opacity(0.5)
                                        Image(systemName: "camera.circle.fill")
                                            .resizable()
                                            .frame(width: UIScreen.main.bounds.width / 5, height: UIScreen.main.bounds.width / 5)
                                    }
                                }
                            } else {
                                if let photoData = selectedPhotoDataAux,
                                   let uiImage = UIImage(data: photoData) {
                                    PhotosPicker(selection: $selectedPhoto,
                                                 matching: .images,
                                                 photoLibrary: .shared()) {
                                        ZStack {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: sideMeasure, height: sideMeasure)
                                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                        }
                                    }
                                }
                            }
                            Spacer()
                        }
                    }
                }
                /*--- ALBUM TITLE SECTION ---*/
                Section {
                    TextField("Name",
                              text: $titleAux,
                              prompt: Text("Album title")
                        .font(.system(size: 20))
                        .fontWeight(.bold))
                    .focused($nameIsFocused)
                    .textInputAutocapitalization(.words)
                    .bold()
                    .multilineTextAlignment(.center)
                    .submitLabel(.done)
                }
                .listSectionSpacing(.compact)
                
                /*--- ALBUM SONGS SECTION ---*/
                Section{
                    Button(action: {
                        nameIsFocused = false
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
                                        .clipShape(RoundedRectangle(cornerRadius: 6))
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
                        if let songToAdd = songStore.addedSongs.first(where: { song in
                            !songAux.contains(where: { $0.name == song.name && $0.artist == song.artist })
                        }) {
                            AddedSongs(songStore: songStore)
                        }
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
                            .focused($nameIsFocused)
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
                            .onChange(of: isDateEnabeled) {
                                nameIsFocused = false
                            }
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
                
                /*--- ALBUM LOCATION SECTION ---*/
                Section {
                    VStack {
                        Toggle("Add location", isOn: $isLocationEnabeled)
                            .onChange(of: isLocationEnabeled) {
                                nameIsFocused = false
                                
                            }
                        if isLocationEnabeled {
                            Divider()
                            HStack {
                                Button(action: {
                                    nameIsFocused = false
                                    locationManager.requestUserLocation()
                                    self.isShowingLocationSheet = true
                                }) {
                                    Label(chosenLocation == "" ? "Add Location" : chosenLocation, systemImage: locationManager.selectedPlace == nil ? "location.circle.fill" : "mappin.circle.fill")
                                        .foregroundColor(.blue)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.top, 5)
                                    /*Label(locationManager.selectedPlace?.name != nil ? "Add Location1" : (locationManager.selectedPlace?.name ?? "Location"), systemImage: locationManager.selectedPlace == nil ? "location.circle.fill" : "mappin.circle.fill")
                                        .foregroundColor(.blue)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.top, 5)*/
                                }

                                
                                if chosenLocation != "" {
                                    Button(action: {
                                        //Reset position
                                        locationManager.selectedPlace = nil
                                        chosenLocation = ""
                                        locationManager.searchText = ""
                                    }) {
                                        Image(systemName: "trash.circle.fill")
                                            .foregroundColor(.red)
                                            .imageScale(.large)
                                    }
                                    
                                    .padding(.leading, 10)
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }
                }
                .listSectionSpacing(.compact)
                
                
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
                        var titleWithNoWhiteSpace = titleAux.trimmingCharacters(in: .whitespaces)
                        album.title = titleWithNoWhiteSpace
                        for songCheck in songStore.addedSongs {
                            if !songAux.contains(where: {$0.name == songCheck.name && $0.artist == songCheck.artist}){
                                album.songs = songAux + songStore.addedSongs
                            }
                        }
                        album.shortDescription = shortDescriptionAux
                        album.coverImage = selectedPhotoDataAux
                        if isDateEnabeled == true && isEndDateEnabled == true {
                            if startDateAux == nil || endDateAux == nil {
                                album.dateFrom = Date()
                                album.dateTo = Date()
                            } else {
                                album.dateFrom = startDateAux
                                album.dateTo = endDateAux
                            }
                        } else if isDateEnabeled == true && isEndDateEnabled == false {
                            if startDateAux == nil {
                                album.dateFrom = Date()
                            } else {
                                album.dateFrom = startDateAux
                                album.dateTo = nil
                            }
                        } else {
                            album.dateFrom = nil
                            album.dateTo = nil
                            
                        }
                        if isLocationEnabeled {
                            chosenLocation = locationManager.selectedPlace?.name ?? ""
                        } else {
                            chosenLocation = ""
                        }
                        album.location = chosenLocation
                        dismiss()
                    }) {
                        Text("Save")
                            .fontWeight(.medium)
                    }
                    .disabled(album.title.isEmpty)
                }
            }
            .task(id: selectedPhoto) {
                if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                    selectedPhotoDataAux = data
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
            selectedPhotoDataAux = album.coverImage
            chosenLocation = album.location
            isLocationEnabeled = !chosenLocation.isEmpty
            if isLocationEnabeled {
                locationManager.searchText = chosenLocation
                print(chosenLocation)
            }
        }
        .onChange(of: locationManager.selectedPlace) { newPlace in
                    chosenLocation = newPlace?.name ?? ""
                }
        .alert(isPresented: $showAlertAlreadyAdded) {
            Alert(title: Text("This song is already in your album."), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $isShowingAddSongView) {
            MusicSearchBar(songStore: songStore)
        }
        .sheet(isPresented: $isShowingLocationSheet) {
            LocationView(locationManager: locationManager, isPresented: $isShowingLocationSheet)
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

