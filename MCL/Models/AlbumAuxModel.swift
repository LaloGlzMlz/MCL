//
//  AlbumAuxModel.swift
//  Flamingo
//
//  Created by Fernando Sensenhauser on 13/05/24.
//

import Foundation
import SwiftUI

class AlbumAuxModel: Identifiable, Hashable {
    static func == (lhs: AlbumAuxModel, rhs: AlbumAuxModel) -> Bool {
          lhs.id == rhs.id
      }
      
      func hash(into hasher: inout Hasher) {
          hasher.combine(id)
      }
    
    init(id: UUID, image: Image, name: String, date: Date) {
        self.id = id
        self.image = image
        self.name = name
        self.date = date
    }
    var id: UUID = UUID()
    var image: Image
    var name: String
    var date = Date()
    
}
