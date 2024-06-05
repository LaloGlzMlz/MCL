//
//  PreviewShareView.swift
//  MCL
//
//  Created by Michel Andre Pellegrin Quiroz on 01/06/24.
//

import SwiftUI

struct PreviewShareView: View {
    @State private var songForEntryView: SongFromCatalog? = nil
    
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
        VStack {
            /*--- ALBUM COVER SECTION ---*/
            AlbumCard(album: album)
                .shadow(color: Color.black.opacity(0.15), radius: 20)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 0))
            
            /*--- ALBUM LOCATION SECTION ---*/
            VStack(alignment: .leading) {
                if album.location != "" {
                    Text(album.location)
                        .foregroundStyle(Color.gray)
                        .font(.footnote)
                        .bold()
                }
                
                /*--- ALBUM DATE SECTION ---*/
                if album.dateTo != nil {
                    HStack {
                        Text(album.dateFrom!, style: .date)
                            .foregroundStyle(Color.gray)
                            .font(.footnote)
                        Text("-")
                            .foregroundStyle(Color.gray)
                            .font(.footnote)
                        Text(album.dateTo!, style: .date)
                            .foregroundStyle(Color.gray)
                            .font(.footnote)
                    }
                } else if album.dateFrom != nil && album.dateTo == nil {
                    HStack {
                        Text(album.dateFrom!, style: .date)
                            .foregroundStyle(Color.gray)
                            .font(.footnote)
                    }
                }
                
                /*--- ALBUM DESCRIPTION SECTION ---*/
                Text(album.shortDescription)
                    .foregroundStyle(Color.gray)
                    .font(.subheadline)
                
                Divider()
                    .padding()
                
                /*--- BOOKLET ENTRIES SECTION ---*/
                ForEach(album.entries) { entry in
                    AlbumEntryCard(entry: entry)
                }
                
                /*--- SONGS SECTION ---*/
                ForEach(album.songs, id: \.id) { song in
                    if song.entries.isEmpty {
                        SongCardCompact(song: song, showingAddEntryButton: true)
                            .shadow(color: Color.black.opacity(0.15), radius: 20)
                    } else {
                        SongEntryCard(song: song)
                    }
                }
                .sheet(item: $songForEntryView) { song in
                    AddSongEntryView(song: song)
                }
            }
        }
        .padding(.horizontal)
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
