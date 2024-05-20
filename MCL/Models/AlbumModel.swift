//
//  AlbumModel.swift
//  MCL
//
//  Created by Eduardo Gonzalez Melgoza on 20/05/24.
//

import Foundation
import SwiftData


// eliminar ID, quitar identifiable, hacer opcionales los campos relacionados.
@Model
final class Album {
    var title: String = ""
    var coverImage: String = ""
    var dateOfAlbum: Date
    
    @Relationship(deleteRule: .cascade)
    var songs: [SongFromCatalog]
    
    init(title: String, coverImage: String, dateOfAlbum: Date, songs: [SongFromCatalog]) {
        self.title = title
        self.coverImage = coverImage
        self.dateOfAlbum = dateOfAlbum
        self.songs = songs
    }
}
