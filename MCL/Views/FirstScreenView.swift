//
//  FirstScreenView.swift
//
//  Created by Fernando Sensenhauser on 13/05/24.
//

import SwiftUI

struct FirstScreenView: View {
    @State var Album: AlbumModel?
    @State var albumTitle: String = ""
    @State var name: String?
    @State private var showingAddAlbumSheet = false
    
    var AlbumArray: [AlbumModel] = [AlbumModel(id: UUID(), image: Image("street"), name: "Last Sunday", date: Date()), AlbumModel(id: UUID(), image: Image("metro"), name: "Last Monday", date: Date()), AlbumModel(id: UUID(), image: Image("man"), name: "Last Kitemmuort", date: Date()), AlbumModel(id: UUID(), image: Image("vesuvio"), name: "Last Suca", date: Date()), AlbumModel(id: UUID(), image: Image("sea"), name: "Last Paolo", date: Date()),]
    
    
    var body: some View {
        NavigationStack {
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
                                    .font(.title3)
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
                .sheet(isPresented: $showingAddAlbumSheet) { AddAlbumSheet() }
                .safeAreaPadding(.horizontal, 25)
                .scrollTargetBehavior(.viewAligned)
                .defaultScrollAnchor(.center)
                .scrollPosition(id: $Album)
            }
            .navigationTitle("Albums")
            .onAppear {
                Album = AlbumArray[2]
            }
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button(action: {
                        showingAddAlbumSheet = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.blue) // Adjust color if needed
                    }
                }
            }
        }
    }
}

#Preview {
    FirstScreenView()
}
