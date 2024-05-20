//
//  Shelf.swift
//  MCL
//
//  Created by Eduardo Gonzalez Melgoza on 20/05/24.
//

import SwiftUI

struct Shelf: View {
    @State var Album: AlbumModel?
    
    var AlbumArray: [AlbumModel] = [AlbumModel(id: UUID(), image: Image("street"), name: "Last Sunday", date: Date()), AlbumModel(id: UUID(), image: Image("metro"), name: "Last Monday", date: Date()), AlbumModel(id: UUID(), image: Image("man"), name: "Last Kitemmuort", date: Date()), AlbumModel(id: UUID(), image: Image("vesuvio"), name: "Last Suca", date: Date()), AlbumModel(id: UUID(), image: Image("sea"), name: "Last Paolo", date: Date()),]
    
    var body: some View {
        VStack(alignment: .center) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center){
                    ForEach(AlbumArray) { album in
                        VStack {
                            NavigationLink(destination: AlbumDetailView(album: album)) {
                                album.image
                                    .resizable()
                                    .frame(width: 200, height: 200)
                                    .padding(.horizontal, 10)
                                    .cornerRadius(15)
                                    .scrollTransition (topLeading: .interactive, bottomTrailing: .interactive, axis: .horizontal) { effect, phase in
                                        effect
                                            .scaleEffect(1.5 - abs(phase.value))
                                            .opacity(1 - abs(phase.value))
                                            .rotation3DEffect(
                                                .degrees(phase.value / 90),
                                                axis: (x: 0, y: 1, z: 0)
                                            )
                                    }
                                    .padding(.horizontal, 0)
                                    .padding(.vertical)
                            }
                            Text(album.name)
                                .font(.title2)
                                .padding(.top, 50)
                            
                            Text(album.date.formatted(date: .abbreviated, time: .omitted))
                                .font(.footnote)
                        }
                    }
                    .padding(.bottom, 50)
                }
                .scrollTargetLayout()
                .padding(.leading, 60)
                .padding(.trailing, 50)
            }
            .onAppear {
                Album = AlbumArray[2]
            }
            .safeAreaPadding(.horizontal, 25)
            .scrollTargetBehavior(.viewAligned)
            .defaultScrollAnchor(.center)
            .scrollPosition(id: $Album)
        }
    }
}

#Preview {
    Shelf()
}
