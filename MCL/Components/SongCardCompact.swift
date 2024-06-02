//
//  SongCardCompact.swift
//  MCL
//
//  Created by Fernando Sensenhauser on 28/05/24.
//

import SwiftUI

struct SongCardCompact: View {
    @StateObject private var viewModel = SongColorViewModel()
    @State private var songForEntryView: SongFromCatalog? = nil
    
    let song: SongFromCatalog
    let showingAddEntryButton: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color.white, location: 0.0),
                        .init(color: Color.black, location: 5.0)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
            // Background gradient with a placeholder color initially
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
                                .padding()
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
                
                Spacer()
                
                if showingAddEntryButton {
                    Button(action: {
                        songForEntryView = song
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .padding()
                            .foregroundColor(.white)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        .sheet(item: $songForEntryView) { song in
            AddSongEntryView(song: song)
        }
        .frame(width: UIScreen.main.bounds.width / 1.1, height: UIScreen.main.bounds.height / 12)
    }
}
