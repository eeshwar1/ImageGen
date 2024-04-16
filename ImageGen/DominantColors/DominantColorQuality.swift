//
//  DominantColorQuality.swift
//  Kollage
//
//  Created by Venkateswaran Venkatakrishnan on 3/30/24.
//  Copyright © 2024 Venky UL. All rights reserved.
//

import Foundation

/// Reoresents how precise the dominant color algorithm should be.
/// The lower the quality, the faster the algorithm.
/// `.best` should only be reserved for very small images.
public enum DominantColorQuality {
    case low
    case fair
    case high
    case best
    
    var prefferedImageArea: CGFloat? {
        switch self {
        case .low:
            return 1_000
        case .fair:
            return 10_000
        case .high:
            return 100_000
        case .best:
            return nil
        }
    }
    
    var kMeansInputPasses: Int {
        switch self {
        case .low:
            return 1
        case .fair:
            return 10
        case .high:
            return 15
        case .best:
            return 20
        }
    }
    
    /// Returns a new size (with the same aspect ratio) that takes into account the quality to match.
    /// For example with a `.low` quality, the returned size will be much smaller.
    /// On the opposite, with a `.best` quality, the returned size will be identical to the original size.
    func targetSize(for originalSize: CGSize) -> CGSize {
        guard let prefferedImageArea = prefferedImageArea else {
            return originalSize
        }
        
        let originalArea = originalSize.area
        
        guard originalArea > prefferedImageArea else {
            return originalSize
        }
        
        return originalSize.transformToFit(in: prefferedImageArea)
    }
}
