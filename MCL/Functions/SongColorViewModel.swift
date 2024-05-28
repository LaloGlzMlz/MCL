//
//  SongColorViewModel.swift
//  MCL
//
//  Created by Fernando Sensenhauser on 28/05/24.
//

import SwiftUI
import CoreImage
import UIKit

class SongColorViewModel: ObservableObject {
    @Published var averageColor: Color = .gray
    
    func fetchImageColor(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let uiImage = UIImage(data: data) else {
                return
            }
            
            DispatchQueue.main.async {
                self.averageColor = self.calculateAverageColor(from: uiImage) ?? .gray
            }
        }.resume()
    }
    
    private func calculateAverageColor(from image: UIImage) -> Color? {
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        let extentVector = CIVector(x: ciImage.extent.origin.x, y: ciImage.extent.origin.y, z: ciImage.extent.size.width, w: ciImage.extent.size.height)
        
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: ciImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull as Any])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        
        let averageColor = Color(
            red: Double(bitmap[0]) / 255.0,
            green: Double(bitmap[1]) / 255.0,
            blue: Double(bitmap[2]) / 255.0,
            opacity: Double(bitmap[3]) / 255.0
        )
        
        return averageColor.adjustedForSaturationAndBrightness(saturationFactor: 2.0, brightnessFactor: 1.2) // Adjust factors here
    }
}

extension Color {
    func adjustedForSaturationAndBrightness(saturationFactor: Double, brightnessFactor: Double) -> Color {
        let components = self.cgColor?.components ?? [0, 0, 0, 1]
        
        var red = components[0]
        var green = components[1]
        var blue = components[2]
        let alpha = components[3]
        
        // Convert RGB to HSB
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        
        UIColor(red: red, green: green, blue: blue, alpha: alpha).getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil)
        
        // Increase saturation and brightness
        saturation = min(saturation * CGFloat(saturationFactor), 3.0)
        brightness = min(brightness * CGFloat(brightnessFactor), 1.0)
        
        // Convert back to RGB
        let adjustedColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        
        // Extract RGB components from adjusted color
        var adjustedRed: CGFloat = 0
        var adjustedGreen: CGFloat = 0
        var adjustedBlue: CGFloat = 0
        adjustedColor.getRed(&adjustedRed, green: &adjustedGreen, blue: &adjustedBlue, alpha: nil)
        
        return Color(red: Double(adjustedRed), green: Double(adjustedGreen), blue: Double(adjustedBlue), opacity: Double(alpha))
    }
}
