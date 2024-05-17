//
//  ImagePicker.swift
//  MCL
//
//  Created by Francesca Ferrini on 16/05/24.
//

import Foundation
import SwiftUI

class ImagePickerCoordinator:NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @Binding var selectedImage: UIImage?
    
    init(image: Binding<UIImage?>){
        _selectedImage = image
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            selectedImage = uiImage
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable{
    
    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = ImagePickerCoordinator
    
    @Binding var selectedImage: UIImage?
    
    var sourceType: UIImagePickerController.SourceType     
    //Se l' immagine cambia
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        uiViewController.sourceType = sourceType
    }
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePickerCoordinator(image: $selectedImage)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        
        return picker
    }
}
