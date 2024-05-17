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
            TextField("Search songs", text: $searchString)
                .onChange(of: searchString) { newValue in
                    fetchMusic()
                }
                .onAppear {
                    fetchMusic()
                }
        }
        .listSectionSpacing(5)
        
        Section {
            List(songs) { song in
                HStack {
                    AsyncImage(url: song.imageURL)
                        .frame(width: 40, height: 40, alignment: .leading)
                    VStack (alignment: .leading) {
                        Text(song.name)
                        Text(song.artist)
                            .font(.footnote)
                    }
                }
            }
        }
    }
    
    private var request: MusicCatalogSearchRequest {
        var request = MusicCatalogSearchRequest(term: searchString, types: [Song.self])
        request.limit = 6
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
                                     imageURL: $0.artwork?.url(width: 40, height: 40))
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
