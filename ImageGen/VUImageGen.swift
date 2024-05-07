//
//  ImageGen.swift
//  ImageGen
//
//  Created by Venkateswaran Venkatakrishnan on 4/13/24.
//

import Cocoa

enum ShapeType: String, CaseIterable {
    
    case Squares = "Squares"
    case Circles = "Circles"
    case Triangles = "Triangles"
    case VerticalBars = "Vertical Bars"
    case HorizontalBars = "Horizontal Bars"
    case Stars = "Stars"
    
}

enum GradientType: String, CaseIterable {
    
    case linear = "Linear"
    case radial = "Radial"
}

enum ImageSize: String, CaseIterable {
    
    case _800x600 = "800 x 600"
    case _800x800 = "800 x 800"
    case _1024x768 = "1024 x 768"
    case _1200x600 = "1200 x 600"
    
    func getSize() -> NSSize {
        
        let rawValue = self.rawValue
        // split width and height from the text of raw value
        let dimensions  = rawValue.components(separatedBy: " x ")
            .compactMap(Int.init)
        return NSSize(width: dimensions[0], height: dimensions[1])
        
    }
}

class VUImageGen {
    
    static func generate(shapeType: ShapeType, imageSize: ImageSize, shapeFactor: CGFloat, meldingFactor: CGFloat, backgroundColor: NSColor, colors: [NSColor], random: Bool, fill: Bool, gradient: Bool, gradientType: GradientType) -> NSImage {
        
        
        let size = imageSize.getSize()
        
        switch shapeType {
            
        case .Squares, .Circles, .Triangles, .Stars:
            return generateShapes(size: NSSize(width: size.width, height: size.height), shapeType: shapeType,
                                  shapeFactor: shapeFactor, meldingFactor: meldingFactor, backgroundColor: backgroundColor, colors: colors,
                                  random: random, fill: fill, gradient: gradient, gradientType: gradientType)
        case .VerticalBars, .HorizontalBars:
            return generateBars(size: NSSize(width: size.width, height: size.height), shapeType: shapeType,
                                shapeFactor: shapeFactor, backgroundColor: backgroundColor, colors: colors,
                                vertical: false, random: random, fill: fill, gradient: gradient, gradientType: gradientType)
            
            
            
        }
    }
    
    
    static func generateShapes(size: NSSize, shapeType: ShapeType, shapeFactor: CGFloat, meldingFactor: CGFloat, backgroundColor: NSColor, colors: [NSColor], random: Bool, fill: Bool, gradient: Bool, gradientType: GradientType) -> NSImage {
        
        guard colors.count > 0 else { return NSImage(size: size) }
        
        return NSImage(size: size,
                       flipped: false,
                       drawingHandler: { rect in
            
            backgroundColor.set()
            rect.fill()
            
            let shapeWidth = CGFloat(size.width/shapeFactor)
            let shapeHeight = shapeWidth
            
            let spacing = CGFloat(size.width/(2.5 * meldingFactor * shapeFactor))
            var xOffset: CGFloat = spacing
            var yOffset: CGFloat = spacing
            var xPos: CGFloat = 0.0
            var yPos: CGFloat = 0.0
            
            let colsOfShapes = Int(size.width/(shapeWidth + spacing))
            let rowsOfShapes = Int(size.width/(shapeHeight + spacing))
            
            var colorIdx = 0
            
            for ridx in 0...rowsOfShapes {
                
                yPos = CGFloat(ridx) * shapeHeight + yOffset
                xOffset = 0
                
                let endY = CGFloat(yPos) + shapeHeight
                if  endY <= size.height || ((endY - size.height) < shapeHeight)
                        
                {
                    for cidx in 0...colsOfShapes {
                        
                        xPos = CGFloat(cidx) * shapeWidth + xOffset
                        
                        let endX = CGFloat(xPos) + shapeWidth
                        if endX <= size.width || ((endX - size.width) < shapeWidth) {
                            
                            let path = getPath(shapeType: shapeType, position: NSPoint(x: xPos, y: yPos),
                                               width: shapeWidth, height: shapeHeight)
                            xOffset += spacing
                            path.lineWidth = 1
                            
                            
                            if fill {
                                
                                colors[colorIdx].set()
                                
                                if gradient {
                                    
                                    let currentColor = colors[colorIdx]
                                    
                                    
                                    // Create a gradient from white to currentColor
                                    let colors: [CGFloat] = [
                                        
                                        1.0, 1.0, 1.0, 1.0,
                                        currentColor.redComponent, currentColor.greenComponent, currentColor.blueComponent, currentColor.alphaComponent
                                        
                                    ]
                                    
                                    
                                    
                                    if let context = NSGraphicsContext.current?.cgContext {
                                        
                                        let baseSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
                                        
                                        let gradient: CGGradient = CGGradient(colorSpace: baseSpace, colorComponents: colors, locations: nil , count: 2)!
                                        
                                        fillGradientInShape(context: context, gradient: gradient, gradientType: gradientType, path: path)
                                        
                                    }
                                    
                                    
                                } else  {
                                    
                                    colors[colorIdx].set()
                                    path.fill()
                                    
                                }
                                
                                
                            } else {
                                
                                colors[colorIdx].set()
                                path.stroke()
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
    
    private static func fillGradientInShape(context: CGContext, gradient: CGGradient, gradientType: GradientType, vertical: Bool = true, path: NSBezierPath) {
        
        
        context.saveGState()
        
        let cgPath = path.cgPath
        
        context.addPath(cgPath)
        context.clip(using: .winding)
        
        let shapeRect = path.bounds
        
        if gradientType == .linear {
            
            var startPoint = CGPointMake(shapeRect.minX, shapeRect.midY)
            var endPoint = CGPointMake(shapeRect.maxX, shapeRect.midY)
            
            if vertical {
                startPoint = CGPointMake(shapeRect.midX, shapeRect.minY)
                endPoint = CGPointMake(shapeRect.midX, shapeRect.maxY)
            }
           
            
            context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: CGGradientDrawingOptions.drawsBeforeStartLocation)
            
            
        } else {
            
            let startCenter = CGPointMake(shapeRect.midX, shapeRect.midY)
            
            let endCenter = CGPointMake(shapeRect.midX, shapeRect.midY)
            
            let startRadius = 0.0
            
            var endRadius = shapeRect.width
            if vertical {
                endRadius = shapeRect.height
            }
           
            
            context.drawRadialGradient(gradient, startCenter: startCenter, startRadius: startRadius, endCenter: endCenter, endRadius: endRadius, options: .drawsBeforeStartLocation)
        }
        
        context.restoreGState()
        
        context.addPath(cgPath)
        context.strokePath()
        
        
    }
    
    private static func getPath(shapeType: ShapeType, position: NSPoint, width: CGFloat, height: CGFloat) -> NSBezierPath {
        
        var path = NSBezierPath()
        
        let shapeRect = NSRect(x: position.x, y: position.y, width: width, height: height)
        
        switch shapeType {
        case .Squares:
            path = NSBezierPath(rect: shapeRect)
        case .Circles:
            path = NSBezierPath(ovalIn: shapeRect)
        case .Triangles:
            path.move(to: NSPoint(x: shapeRect.midX, y: shapeRect.minY))
            path.line(to: NSPoint(x: shapeRect.maxX, y: shapeRect.maxY))
            path.line(to: NSPoint(x: shapeRect.minX, y: shapeRect.maxY))
            path.close()
        case .Stars:
            path = getStarPath(rect: shapeRect)
            
        default:
            path = NSBezierPath(rect: shapeRect)
        }
        
        path.lineWidth = 1
        
        return path
    }
    
    static func getStarPath(rect: NSRect, corners: Int = 5) -> NSBezierPath {
        
        //      let corners: Int = 10
        let smoothness: Double = 0.45
        
        // draw from the center of our rectangle
        let center = NSPoint(x: rect.width / 2, y: rect.height / 2)
        
        // start from directly upwards (as opposed to down or to the right)
        var currentAngle = -CGFloat.pi / 2
        
        // calculate how much we need to move with each star corner
        let angleAdjustment = .pi * 2 / Double(corners * 2)
        
        // figure out how much we need to move X/Y for the inner points of the star
        let innerX = center.x * smoothness
        let innerY = center.y * smoothness
        
        // we're ready to start with our path now
        let path = NSBezierPath()
        
        // move to our initial position
        path.move(to: NSPoint(x: center.x * cos(currentAngle), y: center.y * sin(currentAngle)))
        
        // track the lowest point we draw to, so we can center later
        var bottomEdge: Double = 0
        
        // loop over all our points/inner points
        for corner in 0..<corners * 2  {
            // figure out the location of this point
            let sinAngle = sin(currentAngle)
            let cosAngle = cos(currentAngle)
            let bottom: Double
            
            // if we're a multiple of 2 we are drawing the outer edge of the star
            if corner.isMultiple(of: 2) {
                // store this Y position
                bottom = center.y * sinAngle
                
                // …and add a line to there
                path.line(to: NSPoint(x: center.x * cosAngle, y: bottom))
            } else {
                // we're not a multiple of 2, which means we're drawing an inner point
                
                // store this Y position
                bottom = innerY * sinAngle
                
                // …and add a line to there
                path.line(to: NSPoint(x: innerX * cosAngle, y: bottom))
            }
            
            // if this new bottom point is our lowest, stash it away for later
            if bottom > bottomEdge {
                bottomEdge = bottom
            }
            
            // move on to the next corner
            currentAngle += angleAdjustment
        }
        
        // figure out how much unused space we have at the bottom of our drawing rectangle
        
        path.close()
        let unusedSpace = (rect.height / 2 - bottomEdge) / 2
        
        // create and apply a transform that moves our path down by that amount, centering the shape vertically
        // also tranform by origin coordinates of the position rectange passed to ensure the star is within the required bounds
        
        let transform = AffineTransform(translationByX: center.x + rect.origin.x, byY: center.y + rect.origin.y + unusedSpace)
        
        path.transform(using: transform)
        
        return path
        
        
    }
    
    static func generateBars(size: NSSize, shapeType: ShapeType, shapeFactor: CGFloat, backgroundColor: NSColor, colors: [NSColor], vertical: Bool, random: Bool, fill: Bool, gradient: Bool, gradientType: GradientType) -> NSImage {
        
        guard colors.count > 0 else { return NSImage(size: size) }
        
        
        switch shapeType {
            
        case .VerticalBars:
            
            return generateVerticalBars(size: size, shapeFactor: shapeFactor, backgroundColor: backgroundColor, colors: colors, random: random, fill: fill, gradient: gradient, gradientType: gradientType)
            
        case .HorizontalBars:
            
            return generateHorizontalBars(size: size, shapeFactor: shapeFactor, backgroundColor: backgroundColor, colors: colors, random: random, fill: fill, gradient: gradient, gradientType: gradientType)
        default:
            return generateHorizontalBars(size: size, shapeFactor: shapeFactor, backgroundColor: backgroundColor, colors: colors, random: random, fill: fill, gradient: gradient, gradientType: gradientType)
            
        }
    }
    
    
    
    static func generateVerticalBars(size: NSSize, shapeFactor: CGFloat, backgroundColor: NSColor, colors: [NSColor], random: Bool, fill: Bool, gradient: Bool, gradientType: GradientType) -> NSImage {
        
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
                    
                    let path = NSBezierPath(rect: NSRect(x: xPos, y: 0, width: shapeWidth, height: shapeHeight))
                    xOffset += spacing
                    path.lineWidth = 1
                    
                    if fill {
                        
                        if gradient {
                            
                            let currentColor = colors[colorIdx]
                            
                            
                            // Create a gradient from white to currentColor
                            let colors: [CGFloat] = [
                                
                                1.0, 1.0, 1.0, 1.0,
                                currentColor.redComponent, currentColor.greenComponent, currentColor.blueComponent, currentColor.alphaComponent
                                
                            ]
                            
                            
                            if let context = NSGraphicsContext.current?.cgContext {
                                
                                let baseSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
                                
                                let gradient: CGGradient = CGGradient(colorSpace: baseSpace, colorComponents: colors, locations: nil , count: 2)!
                                
                                fillGradientInShape(context: context, gradient: gradient, gradientType: gradientType, vertical: true, path: path)
                                
                            }
                            
                            
                        } else {
                            
                            colors[colorIdx].set()
                            path.fill()
                            
                        }
                        
                    } else {
                        
                        colors[colorIdx].setStroke()
                        path.stroke()
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
    
    
    static func generateHorizontalBars(size: NSSize, shapeFactor: CGFloat, backgroundColor: NSColor, colors: [NSColor], random: Bool, fill: Bool, gradient: Bool, gradientType: GradientType) -> NSImage {
        
        
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
                    
                    let path = NSBezierPath(rect: NSRect(x: 0, y: yPos, width: shapeWidth, height: shapeHeight))
                    yOffset += spacing
                    path.lineWidth = 1
                    
                    if fill {
                        
                        
                        if gradient {
                            
                            let currentColor = colors[colorIdx]
                            
                            
                            // Create a gradient from white to currentColor
                            let colors: [CGFloat] = [
                                
                                1.0, 1.0, 1.0, 1.0,
                                currentColor.redComponent, currentColor.greenComponent, currentColor.blueComponent, currentColor.alphaComponent
                                
                            ]
                            
                            
                            if let context = NSGraphicsContext.current?.cgContext {
                                
                                let baseSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
                                
                                let gradient: CGGradient = CGGradient(colorSpace: baseSpace, colorComponents: colors, locations: nil , count: 2)!
                                
                                fillGradientInShape(context: context, gradient: gradient, gradientType: gradientType, vertical: false, path: path)
                                
                            }
                            
                            
                        } else {
                            
                            colors[colorIdx].set()
                            path.fill()
                            
                        }
                        
                        
                    } else {
                        
                        colors[colorIdx].setStroke()
                        path.stroke()
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
