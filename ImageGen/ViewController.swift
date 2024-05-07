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
            self.imageGenerator.colors = colors
            refreshImage()
        }
    }
    
    
    @IBOutlet weak var colorTableView: NSTableView!
    
    @IBOutlet weak var imageView: NSImageView!
    
    var imageGenerator = VUImageGen()
    
    @IBOutlet weak var spinner: NSProgressIndicator!
    
    @IBOutlet weak var labelStatus: NSTextField!
    
    @IBOutlet weak var sliderShapeFactor: NSSlider!
    
    @IBOutlet weak var labelShapeFactor: NSTextField!
    
    @IBOutlet weak var labelMeldingFactor: NSTextField!
    
    @IBOutlet weak var popupButtonShapeType: NSPopUpButton!
    
    @IBOutlet weak var inputImageView: VUDragDropImageView!
    
    @IBOutlet weak var buttonOpenImage: NSButton!
    @IBOutlet weak var buttonRandomColor: NSButton!
    
    @IBOutlet weak var colorWell: NSColorWell!
    
    @IBOutlet weak var radioColors: NSButton!
    @IBOutlet weak var radioImage: NSButton!
    
    @IBOutlet weak var popupButtonSize: NSPopUpButton!
    
    @IBOutlet weak var popupButtonGradientType: NSPopUpButton!
    
    let numberFormatter = NumberFormatter()
    
    override func viewWillAppear() {
        
        self.imageGenerator.colors = self.colors
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        imageView.wantsLayer = true
        imageView.layer?.borderColor = NSColor.lightGray.cgColor
        imageView.layer?.borderWidth = 2
        
        imageView.clipsToBounds = true
        imageView.imageScaling = .scaleProportionallyDown
        
        randomColors()
        
        colorTableView.delegate = self
        colorTableView.dataSource = self
        
        colorTableView.reloadData()
        
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        
        spinner.isHidden = true
        
        labelShapeFactor.stringValue = numberFormatter.string(from: NSNumber(value:self.imageGenerator.shapeFactor))!
        
        labelMeldingFactor.stringValue = numberFormatter.string(from: NSNumber(value:self.imageGenerator.meldingFactor))!
        
        
        radioColors.state = .on
        inputImageView.isEnabled = false
        inputImageView.vc = self
        buttonOpenImage.isEnabled = false
        colorWell.isEnabled = true
        
        popupButtonShapeType.removeAllItems()
        
        for type in VUImageGen.ShapeType.allCases {
            
            popupButtonShapeType.addItem(withTitle: type.rawValue)
        }
        
        popupButtonGradientType.removeAllItems()
        
        for type in VUImageGen.GradientType.allCases {
            
            popupButtonGradientType.addItem(withTitle: type.rawValue)
        }
        
        popupButtonSize.removeAllItems()
        
        for size in VUImageGen.ImageSize.allCases {
            
            popupButtonSize.addItem(withTitle: size.rawValue)
        }
    }
    
    func refreshImage() {
     
        self.imageView.image = self.imageGenerator.image
        
    }
    
    @IBAction func addColorChanged(_ sender: NSColorWell) {
        
        
        if !self.colors.contains(sender.color) && !matchColor(color: sender.color, colors: self.colors) {
            
            if self.colors.count > 10 {
                
                self.colors.remove(at: 0)
            }
            self.colors.append(sender.color)
            colorTableView.reloadData()
        }
        
        
    }
    
    @IBAction func backgroundColorChanged(_ sender: NSColorWell) {
        
        
        self.imageGenerator.backgroundColor = sender.color
        self.refreshImage()
        
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
        
        self.imageGenerator.refreshImage()
        self.refreshImage()
        
    }
    
    @IBAction func shapeTypeChanged(_ sender: NSPopUpButton) {
        
        if let selectedItem = sender.selectedItem {
            
            if let shapeType = VUImageGen.ShapeType(rawValue: selectedItem.title) {
                
                self.imageGenerator.shapeType = shapeType
                refreshImage()
            }
        }
        
        
    }
    
    @IBAction func imageSizeChanged(_ sender: NSPopUpButton) {
        
        if let selectedItem = sender.selectedItem {
            
            if let imageSize = VUImageGen.ImageSize(rawValue: selectedItem.title) {
                
                self.imageGenerator.imageSize = imageSize
                refreshImage()
            }
        }
        
        
    }
    
    @IBAction func colorSequenceChanged(_ sender: NSButton) {
        
        
        self.imageGenerator.randomColor = (sender.state == .on)
        self.refreshImage()
        
        
    }
    
    @IBAction func colorFillChanged(_ sender: NSButton) {
        
        
        self.imageGenerator.fill = (sender.state == .on)
        self.refreshImage()
        
    }
    
    @IBAction func colorFillGradientChanged(_ sender: NSButton) {
        
        
        self.imageGenerator.gradient = (sender.state == .on)
        self.refreshImage()
        
        
    }
    
    @IBAction func gradientTypeChanged(_ sender: NSPopUpButton) {
        
        if let selectedItem = sender.selectedItem {
            
            if let gradientType = VUImageGen.GradientType(rawValue: selectedItem.title) {
                
                self.imageGenerator.gradientType = gradientType
                self.refreshImage()
            }
        }
        
        
    }
    
    @IBAction func autoGenerateChanged(_ sender: NSButton) {
        
        
        self.imageGenerator.autoGenerate = (sender.state == .on)
        
        
    }
    
    @IBAction func shapeFactorSliderChanged(_ sender: NSSlider) {
        
        self.imageGenerator.shapeFactor = sender.doubleValue
        self.labelShapeFactor.stringValue = numberFormatter.string(from: NSNumber(value:sender.doubleValue))!
        self.refreshImage()
        
    }
    
    @IBAction func meldingFactorSliderChanged(_ sender: NSSlider) {
        
        self.imageGenerator.meldingFactor = sender.doubleValue
        self.labelMeldingFactor.stringValue = numberFormatter.string(from: NSNumber(value:sender.doubleValue))!
        self.refreshImage()
    }
    
    
    @IBAction func exportImage(_ sender: NSButton)  {
        
        if let image = self.imageView.image {
            
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
                
                self.inputImageView.image = image
                
            }
            
        }
        
    }
    
    @IBAction func typeSelected(_ sender: NSButton) {
        
        if sender.title == "Colors" {
            
            inputImageView.isEnabled = false
            buttonOpenImage.isEnabled = false
            colorWell.isEnabled = true
            buttonRandomColor.isEnabled = true
        } else {
            
            inputImageView.isEnabled = true
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
            cell.textField?.font = .monospacedSystemFont(ofSize: 12, weight: .light)
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

