//
//  NSImage+Extension.swift
//  ImageGen
//
//  Created by Venkateswaran Venkatakrishnan on 4/14/24.
//

import Cocoa

extension NSImage {
    
    var pngData: Data? {
        
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
        
        // let imageProps = [NSImageCompressionFactor: 0.9] // Tiff/Jpeg
        
        let imageProps = [NSBitmapImageRep.PropertyKey.interlaced: NSNumber(value: true)] // PNG
        return bitmapImage.representation(using: .png, properties: imageProps)
        
        
    }
    
    func pngWrite(to url: URL, options: Data.WritingOptions = .atomic) -> Bool {
        do {
            try pngData?.write(to: url, options: options)
            return true
        } catch {
            print(error)
            return false
        }
    }
    
}
