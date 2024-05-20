//
//  SongModel.swift
//  MCL
//
//  Created by Eduardo Gonzalez Melgoza on 15/05/24.
//

import Foundation
import SwiftData


@Model
final class SongFromCatalog : Identifiable {
    let name: String
    let artist: String
    let imageURL: URL?
    
//    @Relationship(inverse: \Album.songs)
//    var customAlbum: Album?
    
    init(name: String, artist: String, imageURL: URL?) {
        self.name = name
        self.artist = artist
        self.imageURL = imageURL
    }
}
