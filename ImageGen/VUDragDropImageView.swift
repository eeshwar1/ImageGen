//
//  VUDragDropImageView.swift
//  ImageGen
//
//  Created by Venkateswaran Venkatakrishnan on 4/15/24.
//

import Cocoa
import UniformTypeIdentifiers

class VUDragDropImageView: NSImageView {
    
    var vc: ViewController?
    
    override var image: NSImage? {
        
        didSet {
            
            if let image = self.image {
                
                let colors = image.getDominantColors()
                
                if let vc = vc {
                    
                    vc.colors = colors
                }
                
            }
        }
    }
    let NSFilenamesPboardType = NSPasteboard.PasteboardType("NSFilenamesPboardType")

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // Declare and register an array of accepted types
        registerForDraggedTypes([NSPasteboard.PasteboardType.fileURL,
                                 NSPasteboard.PasteboardType.png])
    }

    let fileTypes = ["jpg", "jpeg", "bmp", "png", "gif"]
    var fileTypeIsOk = false
    var droppedFilePath: String?

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        if checkExtension(drag: sender) {
            fileTypeIsOk = true
            return .copy
        } else {
            fileTypeIsOk = false
            return []
        }
    
    }

    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        if fileTypeIsOk {
            return .copy
        } else {
            return []
        }
    }

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        if let board = sender.draggingPasteboard.propertyList(forType: NSFilenamesPboardType) as? NSArray,
           let imagePath = board[0] as? String {
            // THIS IS WERE YOU GET THE PATH FOR THE DROPPED FILE
            droppedFilePath = imagePath
            return true
        }
        return false
    }

    func checkExtension(drag: NSDraggingInfo) -> Bool {
        if let board = drag.draggingPasteboard.propertyList(forType: NSFilenamesPboardType) as? NSArray,
           let path = board[0] as? String {
            let url = NSURL(fileURLWithPath: path)
            if let fileExtension = url.pathExtension?.lowercased() {
                return fileTypes.contains(fileExtension)
            }
        }
        return false
    }
}
