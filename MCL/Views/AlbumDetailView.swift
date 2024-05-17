//
//  AlbumDetailView.swift
//  Flamingo
//
//  Created by Fernando Sensenhauser on 15/05/24.
//

import SwiftUI

struct AlbumDetailView: View {
    var album: AlbumModel
    var body: some View {
        VStack {
            
            album.image
            
            Text(album.name)
            
            Text(album.date.formatted(date: .abbreviated, time: .omitted))
        }
    }
}


