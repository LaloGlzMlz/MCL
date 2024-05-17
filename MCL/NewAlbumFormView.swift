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
    @State private var selectedImage: UIImage?
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView{
            Form{
                VStack{
                    
                    Menu {
                        Button(action: {
                            self.showImagePicker = true
                            self.sourceType = .photoLibrary
                        }) {
                            Label("Choose Photo", systemImage: "photo.on.rectangle")
                        }
                        Button(action:  {
                            self.showImagePicker = true
                            self.sourceType = .camera
                        }){
                            Label("Take Photo", systemImage: "camera")
                        }
                        Button(action: selectFromFile) {
                            Label("Select from file", systemImage: "folder")
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
                              prompt: Text("Album title").font(.system(size: 20))).multilineTextAlignment(.center)
                    Divider()
                    
                    
                    
                    
                    Text("scdndvfdsb")
                }
            }
            .navigationTitle("New album")
            .navigationBarTitleDisplayMode(.large)
            .toolbar{
                ToolbarItemGroup(placement: .topBarLeading){
                    Button(action:{
                        dismiss()
                        print("Cancel")
                    }){
                        Text("Cancel")
                    }
                }
                ToolbarItemGroup(placement:
                        .topBarTrailing){
                            Button(action:{
                                dismiss()
                                print("Add")
                            }){
                                Text("Add")
                            }
                        }
            }
        }.sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: self.$selectedImage, sourceType: self.sourceType)
        }
        
    }
    
    func justDoIt() {
        print("Button was tapped")
    }
    

    func selectFromFile() { }
}

#Preview {
    NewAlbumFormView()
}
