//
//  ViewController.swift
//  ImageGen
//
//  Created by Venkateswaran Venkatakrishnan on 4/7/24.
//

import Cocoa

class ViewController: NSViewController {

    var colors: [NSColor] = [] 
    {
        
        didSet {
            
            colorTableView.reloadData()
            imageGenView.colors = colors
        }
    }
    

    @IBOutlet weak var colorTableView: NSTableView!
    
    @IBOutlet weak var imageGenView: VUImageGenView!
    
    @IBOutlet weak var spinner: NSProgressIndicator!
    
    @IBOutlet weak var labelStatus: NSTextField!
    
    @IBOutlet weak var sliderShapeFactor: NSSlider!
    
    @IBOutlet weak var labelShapeFactor: NSTextField!
    
    @IBOutlet weak var labelMeldingFactor: NSTextField!
    
    @IBOutlet weak var popupButtonShapeType: NSPopUpButton!
    
    @IBOutlet weak var imageView: VUDragDropImageView!
    
    @IBOutlet weak var buttonOpenImage: NSButton!
    @IBOutlet weak var buttonRandomColor: NSButton!
    
    @IBOutlet weak var colorWell: NSColorWell!
    
    @IBOutlet weak var radioColors: NSButton!
    @IBOutlet weak var radioImage: NSButton!
    
    @IBOutlet weak var popupButtonSize: NSPopUpButton!
    
    @IBOutlet weak var popupButtonGradientType: NSPopUpButton!
    
    let numberFormatter = NumberFormatter()
   
    override func viewWillAppear() {
        self.imageGenView.colors = self.colors
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        randomColors()
        
        colorTableView.delegate = self
        colorTableView.dataSource = self
        
        colorTableView.reloadData()
        
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        
        spinner.isHidden = true
        labelShapeFactor.stringValue = numberFormatter.string(from: NSNumber(value:self.imageGenView.shapeFactor))!
        
        labelMeldingFactor.stringValue = numberFormatter.string(from: NSNumber(value:self.imageGenView.meldingFactor))!
        
        imageView.vc = self
        
        radioColors.state = .on
        imageView.isEnabled = false
        buttonOpenImage.isEnabled = false
        colorWell.isEnabled = true
        
        popupButtonShapeType.removeAllItems()
        
        for type in ShapeType.allCases {
            
            popupButtonShapeType.addItem(withTitle: type.rawValue)
        }
        
        popupButtonGradientType.removeAllItems()
        
        for type in GradientType.allCases {
            
            popupButtonGradientType.addItem(withTitle: type.rawValue)
        }
        
        popupButtonSize.removeAllItems()
        
        for size in ImageSize.allCases {
            
            popupButtonSize.addItem(withTitle: size.rawValue)
        }
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
    
    @IBAction func backgroundColorChanged(_ sender: NSColorWell) {
          
        
        self.imageGenView.backgroundColor = sender.color
            
    }
    
    func matchColor(color: NSColor, colors: [NSColor]) -> Bool {
        
        for currentColor in colors {
            
            if currentColor.isSimilar(to: color) {
                
                return true
            }
        }
        
        return false
    }
    
    @IBAction func randomColor(_ sender: NSButton) {
          
       
        randomColors()
        
    }
    
    func randomColors() {
        
        var newColors: [NSColor] = []
        
        for _ in 1...10 {
            
            newColors.append(NSColor.random())
            
        }
        self.colors = newColors
        
    }
    
    @IBAction func generateImage(_ sender: NSButton) {
          
        self.imageGenView.refreshImage()
        
        
    }
    
    @IBAction func shapeTypeChanged(_ sender: NSPopUpButton) {
        
        if let selectedItem = sender.selectedItem {
            
            if let shapeType = ShapeType(rawValue: selectedItem.title) {
                
                self.imageGenView.shapeType = shapeType
            }
        }
        
    
    }
    
    @IBAction func imageSizeChanged(_ sender: NSPopUpButton) {
        
        if let selectedItem = sender.selectedItem {
            
            if let imageSize = ImageSize(rawValue: selectedItem.title) {
                
                self.imageGenView.imageSize = imageSize
            }
        }
        
    
    }
    
    @IBAction func colorSequenceChanged(_ sender: NSButton) {
        

        self.imageGenView.randomColor = (sender.state == .on)
       
    
    }
    
    @IBAction func colorFillChanged(_ sender: NSButton) {
        

        self.imageGenView.fill = (sender.state == .on)
       
    
    }
    
    @IBAction func colorFillGradientChanged(_ sender: NSButton) {
        

        self.imageGenView.gradient = (sender.state == .on)
       
    
    }
    
    @IBAction func gradientTypeChanged(_ sender: NSPopUpButton) {
        
        if let selectedItem = sender.selectedItem {
            
            if let gradientType = GradientType(rawValue: selectedItem.title) {
                
                self.imageGenView.gradientType = gradientType
            }
        }
        
    
    }
    
    @IBAction func autoGenerateChanged(_ sender: NSButton) {
        

        self.imageGenView.autoGenerate = (sender.state == .on)
       
    
    }
    
    @IBAction func shapeFactorSliderChanged(_ sender: NSSlider) {
           
       self.imageGenView.shapeFactor = sender.doubleValue
         self.labelShapeFactor.stringValue = numberFormatter.string(from: NSNumber(value:sender.doubleValue))!
           
    }
    
    @IBAction func meldingFactorSliderChanged(_ sender: NSSlider) {
           
       self.imageGenView.meldingFactor = sender.doubleValue
       self.labelMeldingFactor.stringValue = numberFormatter.string(from: NSNumber(value:sender.doubleValue))!
           
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
        
        if sender.title == "Colors" {
            
            imageView.isEnabled = false
            buttonOpenImage.isEnabled = false
            colorWell.isEnabled = true
            buttonRandomColor.isEnabled = true
        } else {
            
            imageView.isEnabled = true
            buttonOpenImage.isEnabled = true
            colorWell.isEnabled = false
            buttonRandomColor.isEnabled = false
        }
        
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
            text = ""
            cellIdentifier = "Color"
        
        }
        if tableColumn == tableView.tableColumns[1]
        {
            text = color.accessibilityName
            cellIdentifier = "ColorName"
            
        }
        if tableColumn == tableView.tableColumns[2]
        {
            text=color.RGB()
            cellIdentifier = "ColorRGB"
        
        }
        
       
      
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView
        {
            cell.textField?.stringValue = text
            if cellIdentifier == "Color" {
                
                cell.wantsLayer = true
                cell.layer?.backgroundColor = color.cgColor
            }
            return cell
        }
        else
        {
            print("Column: \(String(describing: tableColumn)), ERROR making cell")
            return nil
        }
    }
    
    
}

