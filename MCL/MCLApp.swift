//
//  FlamingoApp.swift
//  Flamingo
//
//  Created by Fernando Sensenhauser on 13/05/24.
//

import SwiftUI
import SwiftData


@main
struct MCLApp: App {
    
    let modelContainer: ModelContainer
    
    init() {
        
        do {
            modelContainer = try ModelContainer(for: Album.self, SongFromCatalog.self)
        } catch {
            fatalError("ModelContainer has not been initialized.")
        }
        
    }
    
    var body: some Scene {
        WindowGroup {
            FirstScreenView()
        }
        .modelContainer(modelContainer)
    }
}
