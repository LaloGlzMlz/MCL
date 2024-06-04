//
//  BookletView.swift
//  MCL
//
//  Created by Michel Andre Pellegrin Quiroz on 21/05/24.
//
// testing branch protection

import SwiftUI
import SwiftData
import SimpleToast

struct BookletView: View {
    @Environment(\.modelContext) private var context
    
    @State private var refreshList = false
    @State private var songsFromAlbum: [SongStore] = []
    @State private var songAux: [SongFromCatalog] = []
    @StateObject private var songStore = SongStore()
    @State private var showConfirmationDialog = false
    @State private var showingEditAlbumSheet: Bool = false
    @State private var showSharePreview = false
    @State private var averageColor: Color = .primary
    
    @State private var showingEditView = false
    
    @State private var showingNewAlbumEntryView = false
    
    @State private var songForEntryView: SongFromCatalog? = nil
    
    
    @State var showAlertForDeletingSong: Bool = false
    @State private var showToast = false
    @State var songToDelete: SongFromCatalog?
    
    var toastOptions = SimpleToastOptions(
        alignment: .bottom,
        hideAfter: 1,
        backdrop: Color.black.opacity(0),
        animation: .default,
        modifierType: .slide
        
    )
    
    @Bindable var album: Album
    
    var body: some View {
        //        NavigationStack { DO NOT PUT NAVIGATION STACK ON THIS VIEW, NEVEEEER!!!!
        ScrollView {
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
                    ForEach($album.songs, id: \.id) { $song in
                        if song.entries.isEmpty {
                            SongCardCompact(song: song, showingAddEntryButton: true)
                                .shadow(color: Color.black.opacity(0.15), radius: 20)
                        } else {
                            SongEntryCard(song: song)
                        }
                        
//                        SwipeSongView(
//                            content: {
//                                if song.entries.isEmpty {
//                                    SongCardCompact(song: song, showingAddEntryButton: true)
//                                        .shadow(color: Color.black.opacity(0.15), radius: 20)
//                                } else {
//                                    SongEntryCard(song: song)
//                                }
//                            },
//                            right: {
//                                HStack {
//                                    ZStack {
//                                        Circle().foregroundStyle(Color.gray.opacity(0.5))
//                                        Button(action: {
//                                            songForEntryView = song
//                                        }) {
//                                            Image(systemName: "plus")
//                                                .foregroundColor(.black)
//                                        }
//                                    }
//                                    ZStack{
//                                        Circle().foregroundStyle(Color.gray.opacity(0.5))
//                                        Button(action: {
//                                            songToDelete = song
//                                            showAlertForDeletingSong.toggle()
//                                        }) {
//                                            Image(systemName: "trash")
//                                                .foregroundColor(.black)
//                                        }
//                                    }
//                                }
//                            },
//                            itemHeight: 50
//                        )
                    }
                    .sheet(item: $songForEntryView) { song in
                        AddSongEntryView(song: song)
                    }
                }
            }
            .padding(.horizontal) // Add horizontal padding to the ScrollView content to prevent clipping by ScrollView
        }
        .navigationTitle(album.title)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button(action: {
                    showingEditAlbumSheet.toggle()
                }) {
                    Label("Edit", systemImage: "pencil")
                }
            }
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button(action: {
                    showConfirmationDialog.toggle()
                }) {
                    Label("Options", systemImage: "plus")
                }
            }
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button(action: {
                    showSharePreview = true
                }) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }
        }
        .confirmationDialog("", isPresented: $showConfirmationDialog, titleVisibility: .hidden) {
            Button(action: {
                showingNewAlbumEntryView = true
            }) {
                Text("Add entry")
            }
            Button("Cancel", role: .cancel) {
                // Cancel action
            }
        }
        .sheet(isPresented: $showingNewAlbumEntryView) {
            AddAlbumEntryView(album: album)
        }
        .sheet(isPresented: $showingEditAlbumSheet) {
            EditAlbumView(album: album)
        }
        .sheet(isPresented: $showSharePreview) {
            PreviewShareView(album: album)
        }
        .confirmationDialog("", isPresented: $showAlertForDeletingSong, titleVisibility: .hidden) {
            Button(action: {
                if let song = songToDelete {
                    deleteSong(song)
                    showToast.toggle()
                }
            }) {
                Text("Delete song")
            }
            Button("Cancel", role: .cancel) {
                
            }
        }
        .simpleToast(isPresented: $showToast, options: toastOptions){
            HStack{
                Image(systemName: "checkmark")
                Text("Song deleted")
                    .bold()
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14.0))
            .shadow(radius: 10)
            
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
    
    func deleteSong(_ song: SongFromCatalog) {
        if let index = album.songs.firstIndex(where: { $0.id == song.id }) {
            album.songs.remove(at: index)
        }
    }
    
    
}
