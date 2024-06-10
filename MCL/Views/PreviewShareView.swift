//
//  PreviewShareView.swift
//  MCL
//
//  Created by Michel Andre Pellegrin Quiroz on 01/06/24.
//

import SwiftUI

struct PreviewShareView: View {
    let album: Album
//    @State private var renderedImage = Image(systemName: "photo")
//    @Environment(\.displayScale) var displayScale
    var body: some View {
        render
        Button("Click to save"){
            guard let image = ImageRenderer(content: render).uiImage else {
                return
            }
            //For saving in users camara roll
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        
//        VStack{
//            renderedImage
//            ShareLink(item: renderedImage, preview: SharePreview(Text("Shared image"), image: renderedImage)){
//                Label("Click to share", systemImage: "square.and.arrow.up")
//            }
//        }
//        //        .onChange(of: text) {render() }
//        .onAppear { render() }
    }
    var render: some View {
        Text("\(album.title)")
    }
//    @MainActor func render() {
//        let renderer = ImageRenderer(content: ShareRenderView(album: album))
//        
//        // make sure and use the correct display scale for this device
//        //        renderer.scale = displayScale
//        
//        if let uiImage = renderer.uiImage {
//            renderedImage = Image(uiImage: uiImage)
//        }
//    }
}