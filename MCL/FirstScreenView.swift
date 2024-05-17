//
//  FirstScreenView.swift
//  Flamingo
//
//  Created by Fernando Sensenhauser on 13/05/24.
//

import SwiftUI

struct FirstScreenView: View {
    @State var Album: AlbumModel?
    @State var albumTitle: String = ""
    @State var name: String?
    var AlbumArray: [AlbumModel] = [AlbumModel(id: UUID(), image: Image("street"), name: "Last Sunday", date: Date()), AlbumModel(id: UUID(), image: Image("metro"), name: "Last Monday", date: Date()), AlbumModel(id: UUID(), image: Image("man"), name: "Last Kitemmuort", date: Date()), AlbumModel(id: UUID(), image: Image("vesuvio"), name: "Last Suca", date: Date()), AlbumModel(id: UUID(), image: Image("sea"), name: "Last Paolo", date: Date()),]
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                ScrollView(.horizontal, showsIndicators: false) {
                    VStack {
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
                                        .padding(.top, 50)
                                    
                                    Text(album.date.formatted(date: .abbreviated, time: .omitted))
                                    
                                }
                            }
                            .padding(.bottom, 50)
                        }
                        .scrollTargetLayout()
                        .padding(.leading, 60)
                        .padding(.trailing, 50)
                    }
                    
                }
                .safeAreaPadding(.horizontal, 25)
                .scrollTargetBehavior(.viewAligned)
                .defaultScrollAnchor(.center)
                .scrollPosition(id: $Album)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(.secondary)
                        .opacity(0.4)
                        .frame(width: 300, height: 50)
                    
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "plus.app")
                                .padding(.trailing)
                            Text("Question of the day")
                                .foregroundStyle(.primary)
                                .padding(.horizontal)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .navigationTitle("Album")
            .searchable(text: $albumTitle)
            .onAppear {
                Album = AlbumArray[2]
            }
            .toolbar {
                ToolbarItem(){
                    Image(systemName: "backward.fill")
                }
                ToolbarItem(){
                    Image(systemName: "plus")
                }
            }
        }
    }
}

#Preview {
    FirstScreenView()
}
