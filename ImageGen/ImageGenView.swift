//
//  ImageGenView.swift
//  ImageGen
//
//  Created by Venkateswaran Venkatakrishnan on 4/7/24.
//

import Cocoa

class ImageGenView: NSView {
    
    var imageView = NSImageView()
    
    var autoGenerate: Bool = true
    
    var shapeType: ShapeType = .Squares {
        didSet {
            
            refreshImageAuto()
        }
    }
    
    var shapeFactor: CGFloat = 50.0 {
        
        didSet {
            
            refreshImageAuto()

        }
    }
    
    var randomColor: Bool = true {
        
        didSet {
            
            refreshImageAuto()

        }
    }
    
    var fill: Bool = true {
        
        didSet {
            
            refreshImageAuto()
        }
    }
    
    var colors: [NSColor] = [] {
        
        didSet {
            
            refreshImageAuto()

        }
        
    }
    
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        setupView()
       
    }
    
    func setupView() {
        
        self.wantsLayer = true
        self.layer?.cornerRadius = 10
        
        setupSubViews()
    }
    
    func setupSubViews() {
        
        imageView.imageScaling = .scaleProportionallyDown
        imageView.wantsLayer = true
        imageView.layer?.borderColor = NSColor.lightGray.cgColor
        imageView.layer?.borderWidth = 2
        
        refreshImage()
        imageView.clipsToBounds = true
        imageView.frame = self.bounds.insetBy(dx: 10, dy: 10)
        self.addSubview(imageView)
        
        
    }
    
    func refreshImageAuto() {
        
        if autoGenerate {
            
            refreshImage()
        }
        
    }
    func refreshImage() {
        
        imageView.image = ImageGen.generate(shapeType: self.shapeType, size: .init(width: self.bounds.width, height: self.bounds.height), shapeFactor: self.shapeFactor, backgroundColor: NSColor.white, colors: self.colors, random: self.randomColor, fill: self.fill)
        
    }
    
    func getImage() -> NSImage? {
        
        if let image = imageView.image {
            
            return image
            
        } else {
            
            return nil
        }
        
    }
    
    
}
