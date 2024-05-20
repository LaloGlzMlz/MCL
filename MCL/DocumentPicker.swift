//
//  DocumentPicker.swift
//  MCL
//
//  Created by Francesca Ferrini on 20/05/24.
//

import Foundation
import SwiftUI
import MobileCoreServices

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> UIViewController {
        let picker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeImage)], in: .import)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(selectedImage: $selectedImage)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        @Binding var selectedImage: UIImage?

        init(selectedImage: Binding<UIImage?>) {
            _selectedImage = selectedImage
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let selectedFileURL = urls.first else { return }
            if let imageData = try? Data(contentsOf: selectedFileURL),
               let image = UIImage(data: imageData) {
                selectedImage = image
            }
        }
    }
}

