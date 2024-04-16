//
//  VUDragDropTarget.swift
//  ImageGen
//
//  Created by Venkateswaran Venkatakrishnan on 4/15/24.
//

import Cocoa

protocol VUDragDropTarget {
    
    func setup()
    
    func shouldAllowDrag(_ draggingInfo: NSDraggingInfo) -> Bool
    
    
}

extension VUDragDropTarget {
    
    var nonURLTypes: Set<NSPasteboard.PasteboardType>  { return [NSPasteboard.PasteboardType.tiff, NSPasteboard.PasteboardType.png, .fileURL]}
    
    var acceptableTypes: Set<NSPasteboard.PasteboardType> { if #available(macOS 10.13, *) {
        return nonURLTypes.union([NSPasteboard.PasteboardType.URL])
    } else {
        return    nonURLTypes
    }
        
    }
    
    func setup() {
        registerForDraggedTypes(Array(acceptableTypes))
    }
    
    let filteringOptions = [NSPasteboard.ReadingOptionKey.urlReadingContentsConformToTypes:NSImage.imageTypes]
    
    func shouldAllowDrag(_ draggingInfo: NSDraggingInfo) -> Bool {
        
        var canAccept = false
        
        let pasteBoard = draggingInfo.draggingPasteboard
        
        if pasteBoard.canReadObject(forClasses: [NSURL.self], options: filteringOptions) {
            canAccept = true
        }
        
        else if let types = pasteBoard.types, nonURLTypes.intersection(types).count > 0 {
            
            canAccept = true
            
        }
        return canAccept
        
    }
    
    var isReceivingDrag = false {
        
        didSet {
            
            if isReceivingDrag {
                self.layer?.borderWidth = 2.0
                self.layer?.borderColor = .init(red: 0, green: 255, blue: 0, alpha: 1.0)
            } else {
                self.layer?.borderWidth = 0.0
                self.layer?.borderColor = .black
            }
            needsDisplay = true
        }
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let allow = shouldAllowDrag(sender)
        isReceivingDrag = allow
        return allow ? .copy : NSDragOperation()
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let allow = shouldAllowDrag(sender)
        return allow
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        isReceivingDrag = false
    }
    
    override func performDragOperation(_ draggingInfo: NSDraggingInfo) -> Bool {
        
        isReceivingDrag = false
        
        let pasteBoard = draggingInfo.draggingPasteboard
        
        let point = convert(draggingInfo.draggingLocation, from: nil)
        
        if let urls = pasteBoard.readObjects(forClasses: [NSURL.self], options:filteringOptions) as? [URL], urls.count > 0 {
            processImageURLs(urls, center: point)
            return true
        }
        else if let image = NSImage(pasteboard: pasteBoard) {
            processImage(image, center: point)
            return true
        }
        
        return false
        
    }
    
    func processImageURLs(_ urls: [URL], center: NSPoint) {
        
        for (index,url) in urls.enumerated() {
            
            if let image = NSImage(contentsOf:url) {
                
                var newCenter = center
                
                print("image")
            }
        }
        
    }
    
    func processImage(_ image: NSImage, center: NSPoint) {
        
        
        print("process image")
    }
}
