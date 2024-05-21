//  AddAlbumView.swift
//  MCL
//
//  Created by Francesca Ferrini on 15/05/24.
//

import SwiftUI
import PhotosUI

//Creo una struct per gestire il picker delle foto

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
        
    }
    
    func selectFromFile() { }
}
