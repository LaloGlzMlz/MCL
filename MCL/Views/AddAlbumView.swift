//  AddAlbumView.swift
//  MCL
//
//  Created by Francesca Ferrini on 15/05/24.
//

import SwiftUI
import PhotosUI
import SwiftData

struct AddAlbumView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State var showImagePicker = false
    @State var showCameraPicker = false
    @State private var selectedImage: UIImage?
    
    // Variables for file management
    @State private var isShowingDocumentPicker = false
    
    // Variables for location management
    @StateObject var locationManager: SearchLocation = .init()
    @State var chosenLocation: String = ""
    @State var showSearchBar = false
    @State private var isLocationEnabeled = false
    @State private var isShowingLocationSheet = false
    
    // Variables for date component
    @State private var startDate: Date? = Date(){
        didSet {
            if let end = endDate, let start = startDate {
                if end < start {
                    endDate = start
                }
            }
        }
    }
    @State private var endDate: Date? = Date(){
        didSet {
            if let end = endDate, let start = startDate {
                if end < start {
                    startDate = end
                }
            }
        }
    }
    
    @State private var isDateEnabeled = false
    @State private var isEndDateEnabled = false
    
    @State private var shortDescription: String = ""
    
    @State private var isShowingAddSongView = false
    @StateObject private var songStore = SongStore()
    
    @State var sideMeasure = UIScreen.main.bounds.width / 1.5
    
    
    @State var selectedPhoto: PhotosPickerItem?
    @State var selectedPhotoData: Data?
    
    @State private var alertNoSong: Bool = false
    
    @State private var entries: [Entry] = []
    
    @Binding var newAlbum: Album?
    
    @State var imageSideMeasure = UIScreen.main.bounds.width / 1.3
    
    @FocusState private var nameIsFocused: Bool
    
    var body: some View {
        NavigationStack {
            Form {
                /*--- ALBUM COVER SECTION ---*/
                Section {
                    VStack {
                        HStack {
                            Spacer()
                            if selectedPhotoData == nil {
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
                                let compressedPhoto = compressImage(selectedPhotoData!)
                                if let photoData =  compressedPhoto,
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
                              text: $title,
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
                Section {
                    Button(action: {
                        nameIsFocused = false //To deseable keyboard when tapping other things
                        self.isShowingAddSongView = true
                    }){
                        Label("Add Song",systemImage: "plus.circle.fill")
                    }
                    List {
                        AddedSongs(songStore: songStore)
                    }
                } header: {
                    Text("Songs")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, -15)
                }
                .textCase(nil)
                
                /*--- ALBUM DESCRIPTION SECTION ---*/
                Section {
                    ZStack(alignment: .topLeading) {
                        if shortDescription.isEmpty {
                            Text("Enter album description...")
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                                .padding(.leading, 5)
                        }
                        TextEditor(text: $shortDescription)
                            .focused($nameIsFocused)
                    }
                    .frame(height: 100)
                } header: {
                    Text("Album description")
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
                                        get: { startDate ?? Date() },
                                        set: { startDate = $0 }
                                    ), displayedComponents: [.date])
                                }
                            } else {
                                VStack {
                                    HStack {
                                        Text("From:")
                                        DatePicker("", selection: Binding(
                                            get: { startDate ?? Date() },
                                            set: { startDate = $0 }
                                        ), displayedComponents: [.date])
                                    }
                                    HStack {
                                        Text("To:")
                                        DatePicker("", selection: Binding(
                                            get: { endDate ?? Date() },
                                            set: { endDate = $0 }
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
                                    Label(locationManager.selectedPlace == nil ? "Add Location" : (locationManager.selectedPlace?.name ?? "Location"), systemImage: locationManager.selectedPlace == nil ? "location.circle.fill" : "mappin.circle.fill")
                                        .foregroundColor(.pink)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.top, 5)
                                }
                                
                                if locationManager.selectedPlace != nil {
                                    Button(action: {
                                        //Reset position
                                        locationManager.selectedPlace = nil
                                        locationManager.searchText = ""
                                    }) {
                                        Image(systemName: "trash.circle.fill")
                                            .foregroundColor(.red)
                                            .imageScale(.large)
                                        //.padding(.top, 20)
                                    }
                                    
                                    .padding(.leading, 10)
                                    // Setting the style of the basket button as a simple action button that is not iterative when opening the modal
                                    .buttonStyle(PlainButtonStyle())
                                }
                                
                            }
                        }
                    }
                }
                .listSectionSpacing(.compact)
            }
            .navigationTitle("New album")
            .navigationBarTitleDisplayMode(.large)
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
                        if title.isEmpty {
                            title = "Untitled"
                        }
                        if !isDateEnabeled {
                            endDate = nil
                            startDate = nil
                        } else if isDateEnabeled && !isEndDateEnabled {
                            endDate = nil
                        }
                        chosenLocation = locationManager.selectedPlace?.name ?? ""
                        if !isLocationEnabeled {
                            chosenLocation = ""
                        }
                        var titleWithNoWhiteSpace = title.trimmingCharacters(in: .whitespaces)
                        let album = Album(
                            title: titleWithNoWhiteSpace,
                            coverImage: selectedPhotoData,
                            shortDescription: shortDescription,
                            dateFrom: startDate,
                            dateTo: endDate,
                            location: chosenLocation,
                            dateCreated: Date(),
                            songs: songStore.addedSongs,
                            entries: entries
                        )
                        context.insert(album)
                        newAlbum = album
                        dismiss()
                    }) {
                        Text("Add")
                            .fontWeight(.medium)
                    }
                    .disabled(songStore.addedSongs.isEmpty)
                }
            }
            .task(id: selectedPhoto) {
                if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                    selectedPhotoData = data
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: self.$selectedImage, sourceType: UIImagePickerController.SourceType.photoLibrary)
                .edgesIgnoringSafeArea(.all)
        }
        .sheet(isPresented: $showCameraPicker) {
            ImagePicker(image: self.$selectedImage, sourceType: UIImagePickerController.SourceType.camera)
                .edgesIgnoringSafeArea(.all)
        }
        .sheet(isPresented: $isShowingDocumentPicker) {
            DocumentPicker(selectedImage: $selectedImage)
        }
        .sheet(isPresented: $isShowingAddSongView) {
            MusicSearchBar(songStore: songStore)
        }
        .sheet(isPresented: $isShowingLocationSheet) {
            LocationView(locationManager: locationManager, isPresented: $isShowingLocationSheet)
        }
    }
    
    func selectFromFile() { }
    
    private func compressImage(_ imageData: Data)  -> Data? {
        guard let uiImage = UIImage(data: imageData) else {
            return nil
        }
        
        guard let compressedImageData = uiImage.jpegData(compressionQuality: 0.3) else {
            return nil
        }
        
        return compressedImageData
    }
}



extension SearchLocation {
    func requestUserLocation() {
        manager.requestLocation()
    }
}


