//
//  ViewController.swift
//  ImageGen
//
//  Created by Venkateswaran Venkatakrishnan on 4/7/24.
//

import Cocoa

class ViewController: NSViewController {

    var colors: [NSColor] = [NSColor.red, NSColor.green, NSColor.blue]
    
    @IBOutlet weak var colorTableView: NSTableView!
    
    @IBOutlet weak var imageGenView: ImageGenView!
    
    override func viewWillAppear() {
        self.imageGenView.colors = self.colors
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        colorTableView.delegate = self
        colorTableView.dataSource = self
        
        colorTableView.reloadData()
        
       
        
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
            
            print("Selected Item: \(selectedItem.title)")
            
            if let shapeType = ShapeType(rawValue: selectedItem.title) {
                
                print("Shape Type: \(shapeType.rawValue)")
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

