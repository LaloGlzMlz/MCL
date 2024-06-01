//
//  EntrySongCard.swift
//  MCL
//
//  Created by Eduardo Gonzalez Melgoza on 01/06/24.
//

import SwiftUI
import SwiftData

struct EntrySongCard: View {
    @StateObject private var viewModel = SongColorViewModel()
    
    let song: SongFromCatalog
    let entry: Entry
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.15), radius: 20)
                    .frame(height: geometry.size.height)
            }
            .frame(width: UIScreen.main.bounds.width / 1.1)
            VStack {
                if entry.prompt != "" {
                    Text(entry.prompt ?? "")
                        .padding([.top, .leading, .trailing])
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                    Divider()
                        .padding(.horizontal)
                }
                Text(entry.entryText)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
