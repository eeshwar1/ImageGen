//
//  ViewController.swift
//  ImageGen
//
//  Created by Venkateswaran Venkatakrishnan on 4/7/24.
//

import Cocoa

class ViewController: NSViewController {

    var colors: [NSColor] = [NSColor.red, NSColor.green, NSColor.blue] {
        
        didSet {
            
            colorTableView.reloadData()
            imageGenView.colors = colors
        }
    }
    
    
    
    @IBOutlet weak var colorTableView: NSTableView!
    
    @IBOutlet weak var imageGenView: ImageGenView!
    
    @IBOutlet weak var spinner: NSProgressIndicator!
    
    @IBOutlet weak var labelStatus: NSTextField!
    
    @IBOutlet weak var sliderShapeFactor: NSSlider!
    
    @IBOutlet weak var labelShapeFactor: NSTextField!
    
    @IBOutlet weak var imageView: VUDragDropImageView!
    
    let numberFormatter = NumberFormatter()
   
    override func viewWillAppear() {
        self.imageGenView.colors = self.colors
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        colorTableView.delegate = self
        colorTableView.dataSource = self
        
        colorTableView.reloadData()
        
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        
        spinner.isHidden = true
        labelShapeFactor.stringValue = numberFormatter.string(from: NSNumber(value:self.imageGenView.shapeFactor))!
        
        imageView.vc = self
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func addColorChanged(_ sender: NSColorWell) {
          
        
        if !self.colors.contains(sender.color) && !matchColor(color: sender.color, colors: self.colors) {
            
            if self.colors.count > 10 {
                
                self.colors.remove(at: 0)
            }
            self.colors.append(sender.color)
            colorTableView.reloadData()
        }
        
        self.imageGenView.colors = self.colors
            
    }
    
    
    func matchColor(color: NSColor, colors: [NSColor]) -> Bool {
        
        for currentColor in colors {
            
            if currentColor.isSimilar(to: color) {
                
                return true
            }
        }
        
        return false
    }
    
    @IBAction func deleteColor(_ sender: NSButton) {
          
        if colorTableView.selectedRowIndexes.count > 0 {
            
            let idx = colorTableView.selectedRowIndexes.first!
            
            self.colors.remove(at: idx)
            
            colorTableView.reloadData()
            
            self.imageGenView.colors = self.colors
            
        } else {
            
            print("Nothing selected to delete")
        }
        
        
    }
    
    @IBAction func shapeTypeChanged(_ sender: NSPopUpButton) {
        
        if let selectedItem = sender.selectedItem {
            
            if let shapeType = ShapeType(rawValue: selectedItem.title) {
                
                self.imageGenView.shapeType = shapeType
            }
        }
        
    
    }
    
    @IBAction func colorSequenceChanged(_ sender: NSButton) {
        

        self.imageGenView.randomColor = (sender.state == .on)
       
    
    }
    
    @IBAction func colorFillChanged(_ sender: NSButton) {
        

        self.imageGenView.fill = (sender.state == .on)
       
    
    }
    
    @IBAction func shapeFactorSliderChanged(_ sender: NSSlider) {
           
         
           
         self.imageGenView.shapeFactor = sender.doubleValue
         self.labelShapeFactor.stringValue = numberFormatter.string(from: NSNumber(value:sender.doubleValue))!
           
    }
    
    
    @IBAction func exportImage(_ sender: NSButton)  {
        
        if let image = self.imageGenView.imageView.image {
            
            let savePanel = NSSavePanel()
            savePanel.canCreateDirectories = true
            savePanel.showsTagField = false
            savePanel.nameFieldStringValue = "ImageGen.png"
            savePanel.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.modalPanelWindow)))
            
            let result = savePanel.runModal()
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue  {
                
                if let fileUrl = savePanel.url {
                    
                    
                    DispatchQueue.main.async {
                        
                        
                        if image.pngWrite(to: fileUrl, options: .atomic) {
                            
                            self.labelStatus.stringValue = "Image exported successfully"
                            self.labelStatus.textColor = NSColor.textColor
                            
                        } else {
                            
                            self.labelStatus.stringValue = "Error saving image"
                            self.labelStatus.textColor = .red
                        }
                        self.spinner.stopAnimation(nil)
                        self.spinner.isHidden = true
                        
                    }
                    
                    
                    self.spinner.isHidden = false
                    self.spinner.startAnimation(nil)
                    self.labelStatus.stringValue = "Exporting..."
                    
                    
                }
            }
            
        } else {
            
            self.labelStatus.stringValue = "Nothing to export"
        }
        
        
    }
    
    
    @IBAction func openImage(_ sender: Any) {
        
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.allowedContentTypes = [.image]
        
        let response = openPanel.runModal()
        
        if response == .OK {
            
            if let image = NSImage(contentsOf: openPanel.urls[0]) {
                
                self.imageView.image = image
            }
            
        }
        
    }

    @IBAction func typeSelected(_ sender: NSButton) {
        
        
    }
    
}

extension ViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.colors.count
    }
    
}

extension ViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    
        
        var text: String = ""
        var cellIdentifier: String = ""
        
        let color = self.colors[row]
        
        
        if tableColumn == tableView.tableColumns[0]
        {
            text = color.accessibilityName
            cellIdentifier = "ColorName"
            
        }
        if tableColumn == tableView.tableColumns[1]
        {
            text=color.RGB()
            cellIdentifier = "ColorRGB"
        
        }
       
      
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView
        {
            cell.textField?.stringValue = text
            return cell
        }
        else
        {
            print("Column: \(String(describing: tableColumn)), ERROR making cell")
            return nil
        }
    }
    
    
}

