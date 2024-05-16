//
//  MusicSearchBar.swift
//  MCL
//
//  Created by Eduardo Gonzalez Melgoza on 15/05/24.
//

import SwiftUI
import SwiftData
import MusicKit


struct MusicSearchBar: View {
    @Environment(\.modelContext) private var modelContext
    @State var songs = [SongFromCatalog]()
    @State private var searchString: String = ""
    
    var body: some View {
        Section {
            TextField("Search", text: $searchString)
                .onChange(of: searchString) { newValue in
                    fetchMusic()
                }
        }
        
        Section {
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
    }
    
    private var request: MusicCatalogSearchRequest {
        var request = MusicCatalogSearchRequest(term: searchString, types: [Song.self])
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
