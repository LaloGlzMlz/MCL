//
//  AlbumModel.swift
//  MCL
//
//  Created by Eduardo Gonzalez Melgoza on 20/05/24.
//

import Foundation
import SwiftData

@Model
final class Album {
    var title: String = ""
    var coverImage: Data?
    var dateOfAlbum: Date
    
    @Relationship(deleteRule: .cascade)
    var songs: [SongFromCatalog]
    
    init(title: String, coverImage: Data? = nil, dateOfAlbum: Date, songs: [SongFromCatalog]) {
        self.title = title
        self.coverImage = coverImage
        self.dateOfAlbum = dateOfAlbum
        self.songs = songs
    }
}
