//
//  CIImage+Extension.swift
//  Kollage
//
//  Created by Venkateswaran Venkatakrishnan on 2/12/23.
//  Copyright © 2023 Venky UL. All rights reserved.
//

import CoreImage
import Cocoa

extension CIImage {
    
    func toNSImage() -> NSImage {
        let renderedImage = NSCIImageRep(ciImage: self)
        let nsImage = NSImage()
        nsImage.addRepresentation(renderedImage)
        return nsImage
    }
}
