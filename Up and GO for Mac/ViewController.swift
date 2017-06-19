//
//  ViewController.swift
//  Up and GO for Mac
//
//  Created by Joseph Di Pasquale on 2017-06-18.
//  Copyright © 2017 SiteWiz. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var importantCheckbox: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var doneButton: NSButton!
    @IBOutlet weak var addButton: NSButton!
    
    var TaskItems : [Task_Item] = []
    
    @IBAction func addButton(_ sender: Any) {
        if textField.stringValue != "" {
            if let context = (NSApplication.shared().delegate as? AppDelegate)?.persistentContainer.viewContext {
                let taskItem = Task_Item(context: context)
                taskItem.name = textField.stringValue
                if importantCheckbox.state == 0 {
                    taskItem.important = false
                } else {
                    taskItem.important = true
                }
                (NSApplication.shared().delegate as? AppDelegate)?.saveAction(nil)
                textField.stringValue = ""
                importantCheckbox.state = 0
                getTaskItems()
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getTaskItems()
        
        // Do any additional setup after loading the view.
    }
    
    func getTaskItems() {
        if let context = (NSApplication.shared().delegate as? AppDelegate)?.persistentContainer.viewContext {
            do {
                TaskItems = try context.fetch(Task_Item.fetchRequest())
            } catch {}
        }
        tableView.reloadData()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return TaskItems.count
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        let Task_Item = TaskItems[tableView.selectedRow]
        if let context = (NSApplication.shared().delegate as? AppDelegate)?.persistentContainer.viewContext {
            context.delete(Task_Item)
            (NSApplication.shared().delegate as? AppDelegate)?.saveAction(nil)
            getTaskItems()
            doneButton.isHidden = true
        }
    }
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let Task_Item = TaskItems[row]
        
        if tableColumn?.identifier == "importantColumn" {
            if let cell = tableView.make(withIdentifier: "importantCell", owner: self) as? NSTableCellView {
                if Task_Item.important {
                    cell.textField?.stringValue = "❗️"
                } else {
                    cell.textField?.stringValue = ""

                }
                return cell
            }
        } else {
            if let cell = tableView.make(withIdentifier: "taskItems", owner: self) as? NSTableCellView {
                cell.textField?.stringValue = Task_Item.name!
                return cell
            }
        }
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        doneButton.isHidden = false
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
}

