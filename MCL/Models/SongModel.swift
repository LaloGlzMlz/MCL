//
//  SongModel.swift
//  MCL
//
//  Created by Eduardo Gonzalez Melgoza on 15/05/24.
//

import Foundation
import SwiftData
import Combine


@Model
final class SongFromCatalog : Identifiable {
    let name: String
    let artist: String
    let imageURL: URL?
    
    init(name: String, artist: String, imageURL: URL?) {
        self.name = name
        self.artist = artist
        self.imageURL = imageURL
    }
}

class SongStore: ObservableObject {
    @Published var addedSongs: [SongFromCatalog] = []
}

class DebouncedState: ObservableObject {
    @Published var currentValue = "" //to store real-time value
    @Published var debouncedValue = "" //to store debounced value
    
    private var subscriber: AnyCancellable?
    
    init(initialValue: String, delay: Double = 0.3){
        _currentValue = Published(initialValue: initialValue)
        _debouncedValue = Published(initialValue: initialValue)
        subscriber = $currentValue
            .debounce(for: .seconds(delay), scheduler: RunLoop.main)
            .sink { [unowned self] value in
                self.debouncedValue = value
            }
    }
}
    
