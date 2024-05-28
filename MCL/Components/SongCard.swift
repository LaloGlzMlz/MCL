//
//  SongCard.swift
//  MCL
//
//  Created by Fernando Sensenhauser on 28/05/24.
//

import SwiftUI

struct SongCard: View {
    @StateObject private var viewModel = SongColorViewModel()
    let song: SongFromCatalog
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(Color.white)
            // Background gradient with a placeholder color initially
            RoundedRectangle(cornerRadius: 5)
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
                                .frame(width: 40, height: 40)
                                .padding()
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
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
    }
}
