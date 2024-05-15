//
//  ContentView.swift
//  MCL
//
//  Created by Eduardo Gonzalez Melgoza on 14/05/24.
//

import SwiftUI
import SwiftData
import MusicKit

struct Track: Identifiable, Hashable {
    var id = UUID()
    let name: String
    let artist: String
    let imageURL: URL?
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State var songs = [Track]()

    var body: some View {
        NavigationView {
            List(songs) { song in
                HStack {
                    AsyncImage(url: song.imageURL)
                        .frame(width: 75, height: 75, alignment: .center)
                    VStack {
                        Text(song.name)
                            .font(.title3)
                        Text(song.artist)
                            .font(.footnote )
                    }
                }
            }
        }
        .onAppear {
            fetchMusic()
        }
    }
    
    private var request: MusicCatalogSearchRequest {
        var request = MusicCatalogSearchRequest(term: "Thought contagion", types: [Song.self])
        request.limit = 20
        return request
    }
    
    
    private func fetchMusic() {
        Task {
            let status = await MusicAuthorization.request()
            switch status {
            case .authorized:
                do {
                    let result = try await request.response()
                    self.songs = result.songs.compactMap({
                        return .init(name: $0.title,
                                     artist: $0.artistName,
                                     imageURL: $0.artwork?.url(width: 75, height: 75))
                    })
                } catch {
                    print(String(describing: error))
                }
                break
            default:
                break
            }
        }
    }
}
