//  AddAlbumView.swift
//  MCL
//
//  Created by Francesca Ferrini on 15/05/24.
//

import SwiftUI
import PhotosUI
import SwiftData

//Creo una struct per gestire il picker delle foto

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
    
    @State var selectedPhoto: PhotosPickerItem?
    @State var selectedPhotoData: Data?
    
    @State private var alertNoSong: Bool = false
    //    @State private var navigateToBooklet: Bool = false
    //    @State private var newAlbum: Album?
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    PhotosPicker(selection: $selectedPhoto,
                                 matching: .images,
                                 photoLibrary: .shared()) {
                        Label("Add album cover image", systemImage: "photo")
                    }
                    
                    if let photoData = selectedPhotoData,
                       let uiImage = UIImage(data: photoData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    
                    if selectedPhotoData != nil {
                        Button(role: .destructive) {
                            withAnimation {
                                selectedPhoto = nil
                                selectedPhotoData = nil
                            }
                        } label: {
                            Label("Clear image selection", systemImage: "xmark")
                                .foregroundStyle(Color.red)
                        }
                    } else {
                        //                        ZStack{
                        //                            RoundedRectangle(cornerRadius: 5.0)
                        //                                .frame(width: sideMeasure, height: sideMeasure)
                        //                                .foregroundStyle(Color.gray)
                        //                                .opacity(0.5)
                        //                            Image(systemName: "camera.circle.fill")
                        //                                .resizable()
                        //                                .frame(width: UIScreen.main.bounds.width/5, height: UIScreen.main.bounds.width/5)
                        //                                        .foregroundStyle(Color.white)
                        //                        }
                    }
                }
                Section {
                    VStack {
                        Menu {
                            Button(action: {
                                self.showImagePicker = true
                                
                            }) {
                                Label("Choose Photo", systemImage: "photo.on.rectangle")
                            }
                            Button(action:  {
                                self.showCameraPicker = true
                                
                            }) {
                                Label("Take Photo", systemImage: "camera")
                            }
                            Button(action:  {
                                isShowingDocumentPicker = true
                            }){
                                Label("Select from file", systemImage: "folder")
                            }
                            Button(action: {
                                self.selectedImage = nil
                            }){
                                Label("Remove Photo",systemImage: "trash").foregroundColor(.red)
                            }
                        } label: {
                            if let selectedImage = selectedImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .frame(width: 247, height: 247)
                            } else {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 5.0)
                                        .frame(width: sideMeasure, height: sideMeasure)
                                        .foregroundStyle(Color.gray)
                                        .opacity(0.5)
                                    Image(systemName: "camera.circle.fill")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width/5, height: UIScreen.main.bounds.width/5)
                                    //                                        .foregroundStyle(Color.white)
                                }
                            }
                        }
                        TextField("Name",
                                  text: $title,
                                  prompt: Text("Album title")
                            .font(.system(size: 20))
                            .fontWeight(.bold))
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(15)
                        Divider()
                        HStack{
                            Text("From: ")
                            DatePicker("", selection: $startDate, displayedComponents: [.date])
                        }
                        HStack{
                            Text("To: ")
                            DatePicker("", selection: $endDate, displayedComponents: [.date])
                        }
                        
                    }
                    Button(action: {
                        self.showSearchBar.toggle()
                        
                    }) {
                        Label("Location",systemImage: "location.fill").foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 20)
                    }
                    
                    if showSearchBar {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("Find location here", text: $locationManager.searchText)
                        }
                        .padding(.top, 10)
                    }
                    if let places = locationManager.fetchedPlaces,!places.isEmpty{
                        
                        List{
                            ForEach(places, id: \.self){place in
                                HStack(spacing: 15){
                                    
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.gray)
                                    
                                    VStack(alignment: .leading, spacing: 6){
                                        Text(place.name ?? "")
                                            .font(.title3.bold())
                                        
                                        Text(place.locality ?? "")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            
                            
                        }.listStyle(.plain)
                    }
                }
                Section{
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
                        print("Cancel")
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
                            dateOfAlbum: Date(),
                            songs: songStore.addedSongs
                        )
                        context.insert(album)
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
        
    }
    
    func selectFromFile() { }
}
