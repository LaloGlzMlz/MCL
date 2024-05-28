//
//  BookletView.swift
//  MCL
//
//  Created by Michel Andre Pellegrin Quiroz on 21/05/24.
//

import SwiftUI
import SwiftData

struct BookletView: View {
    @Environment(\.modelContext) private var context
    
    @Bindable var album: Album
    @State private var refreshList = false
    @State private var songsFromAlbum: [SongStore] = []
    @State private var isShowingEditView = false
    @StateObject private var songStore = SongStore()
    @State private var showConfirmationDialog = false
    @State private var showingEditAlbumSheet: Bool = false
    @State private var averageColor: Color = .primary
    
    var body: some View {
        //        NavigationStack { DO NOT PUT NAVIGATION STACK ON THIS VIEW, NEVEEEER!!!!
        ScrollView {
            VStack {
                AlbumCard(album: album)
                    .shadow(color: Color.black.opacity(0.15), radius: 20)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 0))
                
                VStack(alignment: .leading) {
                    //                        Text(album.title)
                    //                            .font(.title)
                    //                            .bold()
                    
                    //                         Description
                    
                    if album.location != "" {
                        Text(album.location)
                            .foregroundStyle(Color.gray)
                            .font(.footnote)
                            .bold()
                        //                            .padding()
                    }
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
                    
                    Text(album.shortDescription)
                        .foregroundStyle(Color.gray)
                        .font(.subheadline)
                    ForEach($album.songs) { $song in
                        SongView(song: song)
                            .frame(width: UIScreen.main.bounds.width/1.1, height: UIScreen.main.bounds.height/12)
                            .shadow(color: Color.black.opacity(0.15), radius: 20)
                    }
                }
            }
            .padding(.horizontal) // Add horizontal padding to the ScrollView content to prevent clipping by ScrollView
        }
        .navigationTitle(album.title)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button(action: {
                    showingEditAlbumSheet = true
                }) {
                    Label("Edit", systemImage: "pencil")
                }
            }
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button(action: {
                    showConfirmationDialog = true
                }) {
                    Label("Options", systemImage: "plus")
                }
            }
        }
        .confirmationDialog("", isPresented: $showConfirmationDialog, titleVisibility: .hidden) {
            Button("Add Entry") {
                // Action 1
            }
            //            Button("Add...") {
            //
            //            }
            Button("Cancel", role: .cancel) {
                // Cancel action
            }
        }
        .sheet(isPresented: $showingEditAlbumSheet) {
            EditAlbumView(album: album)
        }
        .onAppear {
            
        }
    }
    private func calculateAverageColor(from image: UIImage) -> Color? {
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        let extentVector = CIVector(x: ciImage.extent.origin.x, y: ciImage.extent.origin.y, z: ciImage.extent.size.width, w: ciImage.extent.size.height)
        
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: ciImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull as Any])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        
        return Color(red: Double(bitmap[0]) / 255.0, green: Double(bitmap[1]) / 255.0, blue: Double(bitmap[2]) / 255.0, opacity: Double(bitmap[3]) / 255.0)
    }
    
    
}
