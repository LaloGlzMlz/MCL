//
//  AlbumCard.swift
//  MCL
//
//  Created by Eduardo Gonzalez Melgoza on 21/05/24.
//
//

import SwiftUI
import SwiftData

struct AlbumCard: View {
    @Environment(\.modelContext) private var context
    
    @State var frameSideMeasure = UIScreen.main.bounds.width/1.2
    @State var imageSideMeasure = UIScreen.main.bounds.width/1.3
    
    let album: Album
    let isExpanded: Bool
    
    var body: some View {
        Spacer()
        ZStack {
            RoundedRectangle(cornerRadius: 5)
//                .shadow(color: Color.black.opacity(0.3), radius: 20)
                .frame(width: isExpanded ? UIScreen.main.bounds.width : UIScreen.main.bounds.width/1.2, height: isExpanded ? UIScreen.main.bounds.height * 0.6 : UIScreen.main.bounds.width/1.2)
                                .foregroundStyle(.white)
            
            if let selectedPhotoData = album.coverImage,
               let uiImage = UIImage(data: selectedPhotoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: isExpanded ? UIScreen.main.bounds.width : UIScreen.main.bounds.width/1.3, height: isExpanded ? UIScreen.main.bounds.height * 0.6 : UIScreen.main.bounds.width/1.3)
                    .clipShape(RoundedRectangle(cornerRadius: 0))
                    .opacity(0.9)
            }
            
            VStack {
                Spacer()
                HStack {
//                    Spacer()
                    Text(album.title)
                        .font(.title)
                        .bold()
                        .shadow(color: Color.black.opacity(1), radius: 20)
                        .foregroundStyle(Color.white)
                        .padding()
                        .opacity(0.9)
                    Spacer()
                }
            }
            .frame(width: isExpanded ? UIScreen.main.bounds.width : UIScreen.main.bounds.width/1.3, height: isExpanded ? UIScreen.main.bounds.height * 0.6 : UIScreen.main.bounds.width/1.3, alignment: .bottomLeading)

            // Overlay to give album card a gradient to look more physical
            RoundedRectangle(cornerRadius: 5)
                .frame(width: frameSideMeasure, height: frameSideMeasure)
                .opacity(0.1)
                .foregroundStyle(LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color.white, location: 0.0),
                        .init(color: Color.black, location: 1.5)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
        }
        Spacer()
    }
}
