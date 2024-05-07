//
//  ImageGenView.swift
//  ImageGen
//
//  Created by Venkateswaran Venkatakrishnan on 4/7/24.
//

import Cocoa

class VUImageGenView: NSView {
    
    var imageView = NSImageView()
    
    var imageGenerator = VUImageGen()
    
    
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
        
        imageView.wantsLayer = true
        imageView.layer?.borderColor = NSColor.lightGray.cgColor
        imageView.layer?.borderWidth = 2
        
        imageView.clipsToBounds = true
        imageView.frame = self.bounds.insetBy(dx: 10, dy: 10)
        imageView.imageScaling = .scaleProportionallyDown
        self.addSubview(imageView)
        
        refreshImage()
        
    }
    
    
    
    func refreshImage() {
        
        self.imageView.image = self.imageGenerator.image
        
    }
    
    func getImage() -> NSImage? {
        
        if let image = imageView.image {
            
            return image
            
        } else {
            
            return nil
        }
        
    }
    
    
}
