//
//  ImageGen.swift
//  ImageGen
//
//  Created by Venkateswaran Venkatakrishnan on 4/13/24.
//

import Cocoa

enum ShapeType: String {
    
    case Squares = "Squares"
    case VerticalBars = "Vertical Bars"
    case HorizontalBars = "Horizontal Bars"
    
}

class ImageGen {
    
    static func generate(shapeType: ShapeType, size: NSSize, shapeFactor: CGFloat, backgroundColor: NSColor, colors: [NSColor], random: Bool, fill: Bool) -> NSImage {
        
        switch shapeType {
            
        case .Squares:
            return generateSquares(size: .init(width: size.width, height: size.height), shapeFactor: shapeFactor, backgroundColor: NSColor.white, colors: colors, random: random, fill: fill)
        case .VerticalBars:
            return generateBars(size: .init(width: size.width, height: size.height), shapeFactor: shapeFactor, backgroundColor: NSColor.white, colors: colors, vertical: true, random: random, fill: fill)
        case .HorizontalBars:
            return generateBars(size: .init(width: size.width, height: size.height), shapeFactor: shapeFactor, backgroundColor: NSColor.white, colors: colors, vertical: false, random: random, fill: fill)
            
        }
    }
    
    static func generateSquares(size: NSSize, shapeFactor: CGFloat, backgroundColor: NSColor, colors: [NSColor], random: Bool, fill: Bool) -> NSImage {
        
        guard colors.count > 0 else { return NSImage(size: size) }
        
        return NSImage(size: size,
                                  flipped: false,
                                  drawingHandler: { rect in
            
            backgroundColor.set()
            rect.fill()
            
            let shapeWidth = CGFloat(size.width/shapeFactor)
            let shapeHeight = CGFloat(size.width/shapeFactor)

            let spacing = CGFloat(size.width/(2.5 * shapeFactor))
            var xOffset: CGFloat = spacing
            var yOffset: CGFloat = spacing
            var xPos: CGFloat = 0.0
            var yPos: CGFloat = 0.0
            
            let colsOfShapes = Int(size.width/(shapeWidth + spacing))
            let rowsOfShapes = Int(size.width/(shapeHeight + spacing))
            
            var colorIdx = 0
            
            for ridx in 0...rowsOfShapes {
                
                yPos = CGFloat(ridx) * shapeHeight + yOffset
                xOffset = spacing
                if CGFloat(yPos) + shapeHeight <= size.height
                    
                {
                    for cidx in 0...colsOfShapes {
                        
                        xPos = CGFloat(cidx) * shapeWidth + xOffset
                        
                        if CGFloat(xPos) + shapeWidth <= size.width {
                            
                            let smallRect = NSBezierPath(rect: NSRect(x: xPos, y: yPos, width: shapeWidth, height: shapeHeight))
                            xOffset += spacing
                            smallRect.lineWidth = 2
                            
                            if fill {
                                
                                colors[colorIdx].set()
                                smallRect.fill()
                                
                            } else {
                                
                                colors[colorIdx].setStroke()
                                smallRect.stroke()
                            }
                          
                            
                            if random {
                                
                                colorIdx = Int.random(in: 0..<colors.count)
                                
                            } else {
                                colorIdx += 1
                                
                                if colorIdx >= colors.count {
                                    
                                    colorIdx = 0
                                    
                                }
                            }
                            
                        }
                    }
                   
                }
                yOffset += spacing
            }
            return true
            
        })
        
    }
    
    static func generateBars(size: NSSize, shapeFactor: CGFloat, backgroundColor: NSColor, colors: [NSColor], vertical: Bool, random: Bool, fill: Bool) -> NSImage {
    
        guard colors.count > 0 else { return NSImage(size: size) }
        
        
        if vertical {
            
            return generateVerticalBars(size: size, shapeFactor: shapeFactor, backgroundColor: backgroundColor, colors: colors, random: random, fill: fill)
            
        } else {
            
            return generateHorizontalBars(size: size, shapeFactor: shapeFactor, backgroundColor: backgroundColor, colors: colors, random: random, fill: fill)
        }
    }
    
  
    
    static func generateVerticalBars(size: NSSize, shapeFactor: CGFloat, backgroundColor: NSColor, colors: [NSColor], random: Bool, fill: Bool) -> NSImage {
        
        guard colors.count > 0 else { return NSImage(size: size) }
        
        
        return NSImage(size: size,
                                  flipped: false,
                                  drawingHandler: { rect in
            
            backgroundColor.set()
            rect.fill()
            
            let shapeWidth = CGFloat(size.width/shapeFactor)
            let shapeHeight = size.height
        
            let spacing = 0.0
            var xOffset: CGFloat = 0.0
            var xPos: CGFloat = 0.0
            
            let colsOfShapes = Int(size.width/(shapeWidth + spacing))
            
            var colorIdx = 0
            
         
                for cidx in 0...colsOfShapes {
                    
                    xPos = CGFloat(cidx) * shapeWidth + xOffset
                    
                    if CGFloat(xPos) + shapeWidth <= size.width {
                        
                        let smallRect = NSBezierPath(rect: NSRect(x: xPos, y: 0, width: shapeWidth, height: shapeHeight))
                        xOffset += spacing
                        smallRect.lineWidth = 2
                        
                        if fill {
                            
                            colors[colorIdx].set()
                            smallRect.fill()
                            
                        } else {
                            
                            colors[colorIdx].setStroke()
                            smallRect.stroke()
                        }
                      
                        
                        if random {
                            
                            colorIdx = Int.random(in: 0..<colors.count)
                            
                        } else {
                            colorIdx += 1
                            
                            if colorIdx >= colors.count {
                                
                                colorIdx = 0
                                
                            }
                        }
                        
                    }
                }
               
            
           
            return true
            
        })
        
    }
    
    
    static func generateHorizontalBars(size: NSSize, shapeFactor: CGFloat, backgroundColor: NSColor, colors: [NSColor], random: Bool, fill: Bool) -> NSImage {
        
        
        return NSImage(size: size,
                                  flipped: false,
                                  drawingHandler: { rect in
            
            backgroundColor.set()
            rect.fill()
            
            let shapeWidth = size.width
            let shapeHeight = CGFloat(size.height/shapeFactor)
        
            let spacing = 0.0
            var yOffset: CGFloat = 0.0
            var yPos: CGFloat = 0.0
            
            let rowsOfShapes = Int(size.height/(shapeHeight + spacing))
            
            var colorIdx = 0
            
         
                for cidx in 0...rowsOfShapes {
                    
                    yPos = CGFloat(cidx) * shapeHeight + yOffset
                    
                    if CGFloat(yPos) + shapeHeight <= size.height {
                        
                        let smallRect = NSBezierPath(rect: NSRect(x: 0, y: yPos, width: shapeWidth, height: shapeHeight))
                        yOffset += spacing
                        smallRect.lineWidth = 2
                        
                        if fill {
                            
                            colors[colorIdx].set()
                            smallRect.fill()
                            
                        } else {
                            
                            colors[colorIdx].setStroke()
                            smallRect.stroke()
                        }
                      
                        
                        if random {
                            
                            colorIdx = Int.random(in: 0..<colors.count)
                            
                        } else {
                            colorIdx += 1
                            
                            if colorIdx >= colors.count {
                                
                                colorIdx = 0
                                
                            }
                        }
                        
                    }
                }
               
            
           
            return true
            
        })
        
    }

}
