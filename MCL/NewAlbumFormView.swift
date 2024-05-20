//
//  NewAlbumFormView.swift
//  MCL
//
//  Created by Francesca Ferrini on 15/05/24.
//

import SwiftUI
import PhotosUI

//Creo una struct per gestire il picker delle foto


struct NewAlbumFormView: View {
    @State var showImagePicker = false
    @State var showCameraPicker = false
    @State private var selectedImage: UIImage?
    
    @State private var isShowingDocumentPicker = false

    
    @State private var selectedDates: Set<DateComponents> = []
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
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
                            Image("chosenImage")
                        }
                    }
                    TextField("Name",
                              text: .constant(""),
                              prompt: Text("Album title").font(.system(size: 20)))
                        .multilineTextAlignment(.center)
                    Divider()
                    HStack{
                        DatePicker("", selection: $startDate, displayedComponents: [.date])
                                   
                        DatePicker("", selection: $endDate, displayedComponents: [.date])
                             
                    }
                }
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
                        dismiss()
                        print("Add")
                    }) {
                        Text("Add")
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
        
    }

    func selectFromFile() { }
}



#Preview {
    NewAlbumFormView()
}
