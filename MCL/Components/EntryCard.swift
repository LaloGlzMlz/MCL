//
//  EntryCard.swift
//  MCL
//
//  Created by Eduardo Gonzalez Melgoza on 27/05/24.
//

import SwiftUI
import SwiftData

struct EntryCard: View {
    @Environment(\.modelContext) private var context
    
    let album: Album
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.15), radius: 20)
                .frame(width: UIScreen.main.bounds.width/1.1, height: UIScreen.main.bounds.height/12)
            
            ForEach(album.entries) { entry in
                Text(entry.entryText)
            }
        }
    }
}
