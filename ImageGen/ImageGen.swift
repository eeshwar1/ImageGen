//
//  ImageGen.swift
//  ImageGen
//
//  Created by Venkateswaran Venkatakrishnan on 4/13/24.
//

import Cocoa

class ImageGen {
    
   
    static func generate(size: NSSize, colors: [NSColor], fill: Bool) -> NSImage {
        
        
        return NSImage(size: size,
                                  flipped: false,
                                  drawingHandler: { rect in
            NSColor.gray.set()
            rect.fill()
            
            let shapeWidth = CGFloat(size.width/10)
            let shapeHeight = CGFloat(size.width/10)

            let spacing = CGFloat(size.width/25)
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
                if CGFloat(yPos) + shapeHeight < size.height
                    
                {
                    for cidx in 0...colsOfShapes {
                        
                        xPos = CGFloat(cidx) * shapeWidth + xOffset
                        
                        if CGFloat(xPos) + shapeWidth < size.width {
                            
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
                          
                            
                            colorIdx += 1
                            
                            if colorIdx >= colors.count {
                                
                                colorIdx = 0
                            
                            }
                            
                        }
                    }
                   
                }
                yOffset += spacing
            }
            return true
            
        })
        
    }
    

}
