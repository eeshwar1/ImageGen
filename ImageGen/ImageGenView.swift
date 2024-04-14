//
//  ImageGenView.swift
//  ImageGen
//
//  Created by Venkateswaran Venkatakrishnan on 4/7/24.
//

import Cocoa

class ImageGenView: NSView {
    
    var imageView = NSImageView()
    
    var colors: [NSColor] {
        
        didSet {
            
            refreshImage()
        }
        
    }
    
    override init(frame frameRect: NSRect) {
        
        self.colors = []
        super.init(frame: frameRect)
        
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        
        self.colors = []
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
        
        imageView.image = ImageGen.generate(size: .init(width: 500, height: 500), colors: self.colors, fill: true)
        
        imageView.clipsToBounds = true
        imageView.frame = self.bounds.insetBy(dx: 10, dy: 10)
        self.addSubview(imageView)
        
        
    }
    
    func refreshImage() {
        
        imageView.image = ImageGen.generate(size: .init(width: 500, height: 500), colors: self.colors, fill: true)
    }
    
    
    
    
}
