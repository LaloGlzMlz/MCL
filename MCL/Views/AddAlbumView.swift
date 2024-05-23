//  AddAlbumView.swift
//  MCL
//
//  Created by Francesca Ferrini on 15/05/24.
//

import SwiftUI
import PhotosUI


struct AddAlbumView: View {
    @Environment(\.modelContext) private var context
    @State private var title: String = ""
    @State private var coverImage: String = "This is the cover"
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
    @Environment(\.dismiss) var dismiss
    
    @State var sideMeasure = UIScreen.main.bounds.width/1.5
    
    @State private var isShowingLocationSheet = false
    
    var body: some View {
        NavigationStack {
            Form {
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
                        let album = Album (
                            title: title,
                            coverImage: coverImage,
                            dateOfAlbum: Date()
                        )
                        context.insert(album)
                        dismiss()
                    }) {
                        Text("Add")
                            .fontWeight(.medium)
                    }
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
}

extension SearchLocation {
    func requestUserLocation() {
        manager.requestLocation()
    }
}
