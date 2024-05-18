//
//  FlamingoApp.swift
//  Flamingo
//
//  Created by Fernando Sensenhauser on 13/05/24.
//

import SwiftUI

@main
struct MCLApp: App {
    @StateObject private var songStore = SongStore()
    var body: some Scene {
        WindowGroup {
            MusicSearchBar(songStore: songStore)
        }
    }
}
