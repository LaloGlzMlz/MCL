//
//  ShareRenderView.swift
//  MCL
//
//  Created by Michel Andre Pellegrin Quiroz on 01/06/24.
//

import SwiftUI
import SwiftData

struct ShareRenderView: View {
    let album: Album
    
    var body: some View {
        Text("\(album.title)")
    }
}

#Preview {
    ShareRenderView(album: Album(
        title: "Lalo's Album",
        coverImage: nil,
        shortDescription: "This is the short description.",
        dateFrom: Date(),
        dateTo: Date(),
        location: "Napoli",
        dateCreated: Date(),
        songs: [],
        entries: []
    ))
}
