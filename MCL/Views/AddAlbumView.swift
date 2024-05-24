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
    //variables for file management
    @State private var isShowingDocumentPicker = false
    //variables for location management
    @StateObject var locationManager: SearchLocation = .init()
    @State var showSearchBar = false
    //variables for datepicker management
    @State private var selectedDates: Set<DateComponents> = []
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var isShowingAddSongView = false
    @StateObject private var songStore = SongStore()
    
    @State var sideMeasure = UIScreen.main.bounds.width/1.5
    
    @State private var isShowingLocationSheet = false
    @State var selectedPhoto: PhotosPickerItem?
    @State var selectedPhotoData: Data?
    
    @State private var alertNoSong: Bool = false
    @Binding var newAlbum: Album?

    @State var imageSideMeasure = UIScreen.main.bounds.width/1.3

    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack {
                        if selectedPhotoData == nil {
                            PhotosPicker(selection: $selectedPhoto,
                                         matching: .images,
                                         photoLibrary: .shared()) {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 5.0)
                                        .frame(width: sideMeasure, height: sideMeasure)
                                        .foregroundStyle(Color.gray)
                                        .opacity(0.5)
                                    Image(systemName: "camera.circle.fill")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width/5, height: UIScreen.main.bounds.width/5)
                                        .foregroundStyle(Color.blue)
                                }
                            }
                        } else {
                            if let photoData = selectedPhotoData,
                               let uiImage = UIImage(data: photoData) {
                                PhotosPicker(selection: $selectedPhoto,
                                             matching: .images,
                                             photoLibrary: .shared()) {
                                    ZStack{
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: sideMeasure, height: sideMeasure)
                                            .clipShape(RoundedRectangle(cornerRadius: 5))
                                    }
                                }
                            }
                        }
                        
//                        if selectedPhotoData != nil {
//                            Button(role: .destructive) {
//                                withAnimation {
//                                    selectedPhoto = nil
//                                    selectedPhotoData = nil
//                                }
//                            } label: {
//                                Label("Clear image selection", systemImage: "xmark")
//                                    .foregroundStyle(Color.red)
//                            }
//                        }
//                        Menu {
//                            Button(action: {
//                                self.showImagePicker = true
//                                
//                            }) {
//                                Label("Choose Photo", systemImage: "photo.on.rectangle")
//                            }
//                            Button(action:  {
//                                self.showCameraPicker = true
//                                
//                            }) {
//                                Label("Take Photo", systemImage: "camera")
//                            }
//                            Button(action:  {
//                                isShowingDocumentPicker = true
//                            }){
//                                Label("Select from file", systemImage: "folder")
//                            }
//                            Button(action: {
//                                self.selectedImage = nil
//                            }){
//                                Label("Remove Photo",systemImage: "trash").foregroundColor(.red)
//                            }
//                        } label: {
//                            if let selectedImage = selectedImage {
//                                Image(uiImage: selectedImage)
//                                    .resizable()
//                                    .frame(width: 247, height: 247)
//                            } else {
//                                ZStack{
//                                    RoundedRectangle(cornerRadius: 5.0)
//                                        .frame(width: sideMeasure, height: sideMeasure)
//                                        .foregroundStyle(Color.gray)
//                                        .opacity(0.5)
//                                    Image(systemName: "camera.circle.fill")
//                                        .resizable()
//                                        .frame(width: UIScreen.main.bounds.width/5, height: UIScreen.main.bounds.width/5)
//                                    //                                        .foregroundStyle(Color.white)
//                                }
//                            }
//                        }
                        TextField("Name",
                                  text: $title,
                                  prompt: Text("Album title")
                            .font(.system(size: 20))
                            .fontWeight(.bold))
                        .textInputAutocapitalization(.words)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(15)
//                        TextEditor
                    }
                }
                Section {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("From: ")
                            DatePicker("", selection: $startDate, displayedComponents: [.date])
                        }
                        VStack(alignment: .leading) {
                            Text("To: ")
                            DatePicker("", selection: $endDate, displayedComponents: [.date])
                        }
                    }
                    HStack {
                        Button(action: {
                            locationManager.requestUserLocation()
                            self.isShowingLocationSheet = true
                        }) {
                            Label(locationManager.selectedPlace == nil ? "Location" : (locationManager.selectedPlace?.name ?? "Location"), systemImage: locationManager.selectedPlace == nil ? "location.fill" : "mappin.circle.fill")
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 20)
                        }
                        Button(action: {
                            //Reset position
                            locationManager.selectedPlace = nil
                            locationManager.searchText = ""
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                                .padding(.top, 20)
                        }
                       
                        .padding(.leading, 10)
                        // Setting the style of the basket button as a simple action button that is not iterative when opening the modal
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                Section {
                    Button(action: {
                        self.isShowingAddSongView = true
                    }){
                        Label("Add Song",systemImage: "plus")
                    }
                    
                } header: {
                    Text("Songs")
                        .font(.title2)
                        .bold()
                }
                .textCase(nil)
                Section {
                    List{
                        AddedSongs(songStore: songStore)
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
                        let album = Album (
                            title: title,
                            coverImage: selectedPhotoData,
                            shortDescription: "hello testing",
                            dateFrom: startDate,
                            dateTo: endDate,
                            dateCreated: Date(),
                            songs: songStore.addedSongs
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
        //        .alert(isPresented: $alertNoSong) {
        //            Alert(title: Text("Albums must contain at least one song."), dismissButton: .default(Text("OK")))
        //        }
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
}

extension SearchLocation {
    func requestUserLocation() {
        manager.requestLocation()
    }
}
