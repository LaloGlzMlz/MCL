//
//  BookletView.swift
//  MCL
//
//  Created by Michel Andre Pellegrin Quiroz on 21/05/24.
//


import SwiftUI
import SwiftData
import SimpleToast

struct BookletView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    //@State private var songHeight: CGFloat
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
    
    @State private var navigationBarColor: Color = .clear
    @State private var navigationBarTitleOpacity: Double = 0
    
    @Bindable var album: Album
    
    var body: some View {
        ScrollView {
            VStack {
                GeometryReader { geometry in
                    Color.red.opacity(0.5)
                    let minY = geometry.frame(in: .global).minY
                    let scale = 1 + minY / 350
                    let offset = minY > 0 ? -minY : 0
                    
                    AlbumCard(album: album, isExpanded: true)
                        .frame(height: 350)
                        .scaleEffect(minY > 0 ? scale : 1, anchor: .center)
                        .offset(y: offset)
                        .onChange(of: minY) { newValue in
                            if newValue < -150 {
                                withAnimation {
                                    navigationBarColor = .white
                                    navigationBarTitleOpacity = 1
                                }
                            } else {
                                withAnimation {
                                    navigationBarColor = .clear
                                    navigationBarTitleOpacity = 0
                                }
                            }
                        }
                }
                .frame(height: 350)
            }
            .ignoresSafeArea()
            .padding(.bottom)
            
            VStack(alignment: .leading, spacing: 10) {
                if album.location != "" {
                    Text(album.location)
                        .foregroundStyle(Color.gray)
                        .font(.footnote)
                        .bold()
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
                
                Divider()
                    .padding()
                
                ForEach(album.entries) { entry in
                    ZStack {
                        GeometryReader { geometry in
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(.white)
                                .shadow(color: Color.black.opacity(0.15), radius: 20)
                                .frame(height: geometry.size.height)
                        }
                        .frame(width: UIScreen.main.bounds.width / 1.1)
                        
                        Text(entry.entryText)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                ForEach($album.songs, id: \.id) { $song in
                    //songHeight = calculateHeight(for: song)
                    //SwipeSongView(
                       // content: {
                            if song.entries.isEmpty {
                                SongCardCompact(song: song, showingAddEntryButton: true)
                                    .shadow(color: Color.black.opacity(0.15), radius: 20)
                                
                            } else {
                                
                                SongEntryCard(song: song)
                                
                            }
                           
                       /* } ,
                        right: {
                            HStack {
                                ZStack {
                                    Circle().foregroundStyle(Color.gray.opacity(0.5))
                                    Button(action: {
                                        songForEntryView = song
                                    }) {
                                        Image(systemName: "plus")
                                            .foregroundColor(.black)
                                    }
                                }
                                ZStack {
                                    Circle().foregroundStyle(Color.gray.opacity(0.5))
                                    Button(action: {
                                        songToDelete = song
                                        showAlertForDeletingSong.toggle()
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                        },
                        
                        itemHeight: 50
                    )*/
                    
                }
                
                .sheet(item: $songForEntryView) { song in
                    AddSongEntryView(song: song)
                }
            }
            .padding(.horizontal)
            .padding(.top, 60)
           

            
            Spacer()
            
            .background(navigationBarColor)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "lessthan.circle.fill")
                            .foregroundStyle(.white, .gray)
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {
                        showingEditAlbumSheet = true
                    }) {
                        Label("Modifica", systemImage: "pencil.circle.fill")
                    }
                    .foregroundStyle(.white, .gray)
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {
                        showConfirmationDialog = true
                    }) {
                        Label("Opzioni", systemImage: "plus.circle.fill")
                    }
                    .foregroundStyle(.white, .gray)
                }
            }
            .toolbarBackground(navigationBarColor.opacity(0.3), for: .navigationBar)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .opacity(navigationBarTitleOpacity)
        }
        .ignoresSafeArea()
        .confirmationDialog("", isPresented: $showConfirmationDialog, titleVisibility: .hidden) {
            Button(action: {
                showingNewAlbumEntryView = true
            }) {
                Text("Add Entry")
            }
            Button("Annulla", role: .cancel) {
                // Azione di annullamento
            }
        }
        .sheet(isPresented: $showingNewAlbumEntryView) {
            AddAlbumEntryView(album: album)
        }
        .sheet(isPresented: $showingEditAlbumSheet) {
            EditAlbumView(album: album)
        }
        .confirmationDialog("", isPresented: $showAlertForDeletingSong, titleVisibility: .hidden) {
            Button(action: {
                if let song = songToDelete {
                    deleteSong(song)
                    showToast.toggle()
                }
            }) {
                Text("Elimina canzone")
            }
            Button("Annulla", role: .cancel) {
                
            }
        }
        .simpleToast(isPresented: $showToast, options: toastOptions){
            HStack{
                Image(systemName: "checkmark")
                Text("Canzone eliminata")
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
    
    private func deleteSong(_ song: SongFromCatalog) {
        withAnimation {
            if let index = album.songs.firstIndex(where: { $0.id == song.id }) {
                album.songs.remove(at: index)
            }
        }
    }
   
}
