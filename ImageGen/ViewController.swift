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
          
        if !self.colors.contains(sender.color) {
            self.colors.append(sender.color)
            colorTableView.reloadData()
        }
        
        self.imageGenView.colors = self.colors
            
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

extension NSColor {
    
    func RGB() -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        // minimum decimal digit, eg: to display 2 as 2.00
        formatter.minimumFractionDigits = 2
        // maximum decimal digit, eg: to display 2.5021 as 2.50
        formatter.maximumFractionDigits = 2
        // round up 21.586 to 21.59. But doesn't round up 21.582, making it 21.58
        formatter.roundingMode = .halfUp
        
        let redString = formatter.string(for: self.redComponent)!
        let greenString = formatter.string(for: self.greenComponent)!
        let blueString = formatter.string(for: self.blueComponent)!
        let alphaString = formatter.string(for: self.alphaComponent)!
        	
        return "(\(redString),\(greenString),\(blueString),\(alphaString))"
    }
}
