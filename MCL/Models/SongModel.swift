//
//  SongModel.swift
//  MCL
//
//  Created by Eduardo Gonzalez Melgoza on 15/05/24.
//

import Foundation

struct SongFromCatalog: Identifiable, Hashable {
    var id = UUID()
    let name: String
    let artist: String
    let imageURL: URL?
}
