//
//  SongEntryCard.swift
//  MCL
//
//  Created by Eduardo Gonzalez Melgoza on 01/06/24.
//

import SwiftUI
import SwiftData

struct SongEntryCard: View {
    @StateObject private var viewModel = SongColorViewModel()
    @State private var songForEntryView: SongFromCatalog? = nil
    
    @Bindable var song: SongFromCatalog
    
    var body: some View {
        ZStack {
            /*--- WHITE CARD UNDER COLOR CARD ---*/
            RoundedRectangle(cornerRadius: 10)
                .fill(LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color.white, location: 0.0),
                        .init(color: Color.black, location: 5.0)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
            
            /*--- COLORED CARD CONTAINING EVERYTHING ---*/
            RoundedRectangle(cornerRadius: 10)
                .fill(LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: viewModel.averageColor, location: 0.0),
                        .init(color: Color.black, location: 2.0)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .opacity(0.7)  // Adjust opacity as needed
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                /*--- SONG INFO SECTION ---*/
                HStack {
                    if let url = song.imageURL {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 55, height: 55)
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                    .padding(.leading, 10)
                                    .padding(.top, 10)
                                    .padding(.trailing, 5)
                                    .onAppear {
                                        // Fetch the color when the image appears
                                        viewModel.fetchImageColor(from: url)
                                    }
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        ProgressView()
                    }
                    
                    VStack(alignment: .leading) {
                        Text(song.name)
                            .fontWeight(.medium)
                            .lineLimit(1)
                            .foregroundStyle(Color.white)
                        
                        Text(song.artist)
                            .font(.footnote)
                            .foregroundStyle(Color.white)
                    }
                    .padding(.top, 8)
                    
                    Spacer()
                    
                    Button(action: {
                        songForEntryView = song
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .padding()
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                    .overlay(Color.white)
                    .opacity(0.5)
                    .padding(.horizontal)
                
                /*--- ENTRIES SECTION ---*/
                VStack {
                    ForEach(song.entries.indices, id: \.self) { index in
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(.white)
                                .opacity(0.1)
                            
                            VStack {
                                if song.entries[index].prompt != "" {
                                    Text(song.entries[index].prompt ?? "")
                                        .padding([.top, .leading, .trailing], 10)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundStyle(Color.white)
                                        .bold()
                                        .lineLimit(nil)
                                        .multilineTextAlignment(.leading)
                                    Divider()
                                        .padding(.horizontal)
                                }
                                
                                TextField("Enter text", text: $song.entries[index].entryText)
                                    .padding(10)
                                    .foregroundStyle(Color.white)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                    }
                }
                .padding(10) // VStack padding to create space around the content
            }
            .frame(width: UIScreen.main.bounds.width / 1.1)
            .fixedSize(horizontal: false, vertical: true) // Allow the ZStack to resize vertically based on content
        }
        .sheet(item: $songForEntryView) { song in
            AddSongEntryView(song: song)
        }
    }
}
