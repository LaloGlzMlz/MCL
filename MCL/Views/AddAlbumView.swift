//
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
    @State private var isShowingDocumentPicker = false
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
                                  prompt: Text("Album title").font(.system(size: 20)))
                        .multilineTextAlignment(.center)
                        Divider()
                        HStack{
                            DatePicker("", selection: $startDate, displayedComponents: [.date])
                            
                            DatePicker("", selection: $endDate, displayedComponents: [.date])
                            
                        }
                    }
                }
                Section{
                    Button(action: {
                        self.isShowingAddSongView = true
                    }){
                        Label("Add Song",systemImage: "plus")
                    }
                    
                }
                Section {
                    List{
                        AddedSongs(songStore: songStore)
                    }
                } header: {
                    Text("Songs")
                        .font(.title2)
                        .bold()
                }
                .textCase(nil)
                
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



//#Preview {
//    AddAlbumView()
//}
