//
//  OnBoardingData.swift
//  MCL
//
//  Created by Fernando Sensenhauser on 03/06/24.
//

import Foundation
import SwiftUI

let onBoardingData : [OnBoardinItem] = [
    OnBoardinItem(
        title: {
        var title = AttributedString("Create your own \n Album")
        if let range = title.range(of: "Album") {
            title[range].foregroundColor = Color(hex: "E4255B")
        }
        return title
    }(), image: Image(systemName: "arrow.up.left.arrow.down.right.circle"),
        description: {
        var description = AttributedString("Start creating an album that represent a special time in your life!")
        if let range = description.range(of: "album") {
            description[range].foregroundColor = Color(hex: "E4255B")
        }
            if let range = description.range(of: "special time") {
                description[range].foregroundColor = Color(hex: "E4255B")
            }

        return description
    }()),
    OnBoardinItem( title: {
        var title = AttributedString( "Add \n Songs & \n           Journal")
        if let range = title.range(of: "Songs") {
            title[range].foregroundColor = Color(hex: "E4255B")
        }
        if let range = title.range(of: "Journal") {
            title[range].foregroundColor = Color(hex: "E4255B")
        }
        return title
        }(), image: Image(systemName: "music.note"),
            description: {
            var description = AttributedString("Each song tells a story \n What’s yours?")
            if let range = description.range(of: "song") {
                description[range].foregroundColor = Color(hex: "E4255B")
            }
                if let range = description.range(of: "story") {
                    description[range].foregroundColor = Color(hex: "E4255B")
                }
                if let range = description.range(of: "yours") {
                    description[range].foregroundColor = Color(hex: "E4255B")
                }

            return description
        }()),
    OnBoardinItem(title: {
        var title = AttributedString( "Discover the \n Booklet")
        if let range = title.range(of: "Booklet") {
            title[range].foregroundColor = Color(hex: "E4255B")
        }
        return title
        }(), image: Image(systemName: "book"),
                  description: {
                  var description = AttributedString("Your digital space \n to express and organize \n your music journey!")
                  if let range = description.range(of: "digital space") {
                      description[range].foregroundColor = Color(hex: "E4255B")
                  }
                      if let range = description.range(of: "express") {
                          description[range].foregroundColor = Color(hex: "E4255B")
                      }
                      if let range = description.range(of: "organize") {
                          description[range].foregroundColor = Color(hex: "E4255B")
                      }

                  return description
              }()),
    OnBoardinItem(title: {
        var title = AttributedString( "Share \n your journey")
        if let range = title.range(of: "Share") {
            title[range].foregroundColor = Color(hex: "E4255B")
        }
        return title
        }(), image: Image(systemName: "person.3.fill"),
                  description: {
                  var description = AttributedString("Feel free to share \n your music experience")
                  if let range = description.range(of: "share") {
                      description[range].foregroundColor = Color(hex: "E4255B")
                  }
                      if let range = description.range(of: "music experience") {
                          description[range].foregroundColor = Color(hex: "E4255B")
                      }
                   

                  return description
              }())
                 

]
