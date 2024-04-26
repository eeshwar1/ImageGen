//
//  NSColor+Extension.swift
//  ImageGen
//
//  Created by Venkateswaran Venkatakrishnan on 4/14/24.
//

import Cocoa

extension NSColor {
    
    func RGB() -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        // minimum decimal digit, eg: to display 2 as 2.00
        formatter.minimumFractionDigits = 2
        // maximum decimal digit, eg: to display 2.5021 as 2.50
        formatter.maximumFractionDigits = 2
        // round up 21.586 to 21.59. But doesn't round up 21.582, making it 21.58
        formatter.roundingMode = .halfUp
        
        let redString = formatter.string(for: self.redComponent)!
        let greenString = formatter.string(for: self.greenComponent)!
        let blueString = formatter.string(for: self.blueComponent)!
        let alphaString = formatter.string(for: self.alphaComponent)!
            
        return "(r:\(redString), g:\(greenString), b:\(blueString), a:\(alphaString))"
    }
    
    func isSimilar(to otherColor: NSColor) -> Bool {
        
        let redDifference = self.redComponent - otherColor.redComponent
        let greenDifference = self.greenComponent - otherColor.greenComponent
        let blueDifference = self.blueComponent - otherColor.blueComponent
        let alphaDifference = self.alphaComponent - otherColor.alphaComponent
        
        let colorDifference: Double = (pow(redDifference, 2) + pow(greenDifference,2) + pow(blueDifference, 2) + pow(alphaDifference, 2)).squareRoot()
        
        if colorDifference <= 0.1 {
            
            return true
        }
        
        return false
    }
    
    static func random() -> NSColor {
        
        return NSColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: .random(in: 0...1))
        
        
    }
    
}
