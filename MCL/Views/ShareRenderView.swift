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
