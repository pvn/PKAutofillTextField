//
//  PKAutoListView.swift
//  PKAutofillTextField_Example
//
//  Created by Praveen Kumar Shrivastava on 19/09/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

public protocol PKAutoListViewControllerDelegate: class {
    
    func selectedValue(value: String)
    func removeItem(value: String)
}

open class PKAutoListViewController:UITableViewController {
    
    var items = Set<String>()
    weak var delegate: PKAutoListViewControllerDelegate?
    
    required public init(delegate: PKAutoListViewControllerDelegate) {
        self.delegate = delegate
        super.init(style: .plain)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("number of records \(lists.count)")
        return items.count
    }
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        
        for (index, element) in items.enumerated() {
            if indexPath.row == index {
                cell.textLabel!.text = element
            }
        }
        return cell
    }
    
    open override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            for (index, element) in items.enumerated() {
                if indexPath.row == index {
                    self.deleteRow(tableView, forRowAt: indexPath, element: element)
                }
            }            
        }
    }
    
    private func deleteRow(_ tableView: UITableView, forRowAt indexPath: IndexPath, element: String) {
        items.remove(element)
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        delegate?.removeItem(value: element)
    }
    
    
    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        for (index, element) in items.enumerated() {
            if indexPath.row == index {
                delegate?.selectedValue(value: element)
            }
        }
    }
}
