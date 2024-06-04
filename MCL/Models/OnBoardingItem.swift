//
//  OnBoardingModel.swift
//  MCL
//
//  Created by Fernando Sensenhauser on 03/06/24.
//

import Foundation
import SwiftUI

struct OnBoardinItem: Identifiable {
  var id = UUID()
  var title: AttributedString
  var image: Image
  var description: AttributedString
}
