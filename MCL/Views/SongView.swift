//
//  SongView.swift
//  MCL
//
//  Created by Fernando Sensenhauser on 28/05/24.
//

import SwiftUI
struct SongView: View {
    @StateObject private var viewModel = SongColorViewModel()
    let song: SongFromCatalog
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(viewModel.averageColor.opacity(0.7))
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
                                .frame(width: 40, height: 40)
                                .padding()
                                .onAppear {
                                    viewModel.fetchImageColor(from: url)
                                }
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
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
                    
                    Text(song.artist)
                        .font(.footnote)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
    }
}
