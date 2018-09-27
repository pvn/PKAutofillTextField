//
//  PKAutofillTextField.swift
//  PKAutofillTextField_Example
//
//  Created by Praveen Kumar Shrivastava on 19/09/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func textSize(textFont: UIFont) -> CGSize{
        
        let fontAttributes = [NSAttributedStringKey.font: textFont]
        return (self as NSString).size(withAttributes: fontAttributes as [NSAttributedStringKey : Any])
    }
    
    func prependString(string: String) -> String {
        return string + self
    }
    
    func appendString(string: String) -> String {
        return self + string
    }
}

enum AutoFillTextFieldError: Error {
    case keyMissing
    case outOfStock
}

public protocol PKAutofillTextFieldDelegate: class {
    
    func selectedValue(value: String)
}

//MARK: PKAutofillTextField class

@IBDesignable
open class PKAutofillTextField: UITextField {
    
    var keyIdentifier = ""
    var listVC: PKAutoListViewController?
    var presentingVC: UIViewController?
    weak var autofillTextFieldDelegate: PKAutofillTextFieldDelegate?
    
    var showButton = UIButton(type: .custom)
    var values = Set<String>()
    
    required public init(frame: CGRect, presenting: UIViewController, keyIdentifier: String, delegate: PKAutofillTextFieldDelegate, buttonTitle: String) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        self.autocapitalizationType = .none
        
        self.presentingVC = presenting
        self.keyIdentifier = keyIdentifier
        
        // cleanup old data if exists, for the same key
        cleanup(key: keyIdentifier)
        
        //UITextField delegate
        self.delegate = self
        
        //PKAutofillTextField delegate
        self.autofillTextFieldDelegate = delegate
    
        // init of tableview to show the values
        self.listVC = PKAutoListViewController.init(delegate: self)
        
        // add show button
        addShowButton(title: buttonTitle.prependString(string: "| "))
    }
    
    private func addShowButton(title: String) {
        
        //set button title
        showButton.setTitle(title, for: .normal)
        
        // set button frame size based on text size
        let size = title.textSize(textFont: (showButton.titleLabel?.font)!)
        showButton.frame = CGRect(x: 0, y: 0, width: size.width + 10, height: self.frame.size.height)
        
        // button configuration related to styles
        showButton.setTitleColor(UIColor.lightGray, for: .normal)
        showButton.titleLabel?.textAlignment = .center
        
        // add action for button
        showButton.addTarget(self, action: #selector(self.showTableView), for: .touchUpInside)
        
        self.rightView = showButton
        self.rightViewMode = .unlessEditing
    }

    public func defaultValues(values: Array<String>) {
        
        for value in values {
            saveValue(value: value)
        }
    }
    
    @IBAction func showTableView(_ sender: Any) {
        let items = datasource()
        print("items \(items)")
        if (items.count > 0) {
            displayItems()
        }
        else {
            self.placeholder = "No records found, start typing"            
        }
    }
    
    private func cleanup(key: String) {
        let items = datasource()
        if items.count > 0 {
            PKDataManager.clearAll(forKey: key)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PKAutofillTextField: PKAutoListViewControllerDelegate {
    
    public func selectedValue(value: String) {
        self.text = value
        dismissPopover(shouldShowKeyboard: false)
        self.autofillTextFieldDelegate?.selectedValue(value: value)
    }
    
    public func removeItem(value: String) {
        let items = datasource()
        if items.count > 0 {
            PKDataManager.remove(value, forKey: self.keyIdentifier)
        }
        
        if PKDataManager.isRecordEmpty(forKey: self.keyIdentifier) {
            dismissPopover(shouldShowKeyboard: true)
        }
        
    }
    
    func dismissPopover(shouldShowKeyboard: Bool) {
        DispatchQueue.main.async {
            self.listVC?.dismiss(animated: true, completion: nil)
            if shouldShowKeyboard {
                self.becomeFirstResponder()
            }
            else {
                self.resignFirstResponder()
            }
        }
        
    }
    
}


extension PKAutofillTextField: UITextFieldDelegate {
    
    @available(iOS 10.0, *)
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        saveValue(value: textField.text!)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        saveValue(value: textField.text!)
    }
    
    func saveValue(value: String) {
        
        values.removeAll()
        if !value.isEmpty {
            let items = datasource()
            if items.count > 0 {
                values = Set(items)
            }
            values.insert(value)
            PKDataManager.set(values, forKey: self.keyIdentifier)
        }
        
    }
    
    func datasource() -> Set<String> {
        return PKDataManager.get(forKey: self.keyIdentifier)
    }
    
    private func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // User finished typing (hit return): hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    private func displayItems() {
        
        // refresh table view
        refreshTableView()
        
        // set content size for list table view controller
        self.listVC!.preferredContentSize = CGSize(width: 500, height: 300)
        
        //show list table viewcontroller as popover
        showPopup(self.listVC!, sourceView: self.listVC!.view)
    }
    
    private func refreshTableView() {
        self.listVC!.items = datasource()
        self.listVC!.tableView.reloadData()
    }
    
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        
        let presentationController = PKPopover.configurePresentation(forController: controller)
        presentationController.sourceView = self
        presentationController.sourceRect = self.bounds
        presentationController.permittedArrowDirections = [.down]
        self.presentingVC!.present(controller, animated: true)
    }
}

//MARK: PKDataManager class
// This class is intended to execute the data operation like store, retrieval, removal of items

class PKDataManager {
    
    static let defaults = UserDefaults.standard
    
    static func isKeyPresentInUserDefaults(key: String) -> Bool {
        return defaults.object(forKey: key) != nil
    }
    
    static func set(_ values: Set<String>, forKey key: String) {
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: values)
        defaults.set(encodedData, forKey: key)
        synchronize()
    }
    
    static func get(forKey key: String) -> Set<String>{
        
        if isKeyPresentInUserDefaults(key: key) {
            
            let decoded = defaults.value(forKey: key)
            let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded as! Data )
            return (decodedTeams as? Set<String>)!
        }
        else {
            print("Key \(key) is not found")
        }
        return []
    }
    
    static func clearAll(forKey key: String) {
        if isKeyPresentInUserDefaults(key: key) {
            defaults.removeObject(forKey: key)
            synchronize()
        }
    }
    
    static func synchronize() {
        defaults.synchronize()
    }
    
    static func isRecordEmpty(forKey key: String) -> Bool {
        let items = PKDataManager.get(forKey: key)
        return items.count <= 0
    }
    
    
    static func remove(_ value: String, forKey key: String) {
        var items = self.get(forKey: key)
        items.remove(value)
        
        clearAll(forKey: key)
        
        set(items, forKey: key)
        
        synchronize()
    }
}

//MARK: PKPopover class
// This class in intended to display items as popover for both iPad & iPhone

class PKPopover : NSObject, UIPopoverPresentationControllerDelegate {
    
    private static let sharedInstance = PKPopover()
    
    private override init() {
        super.init()
    }
    
    /* For iOS8.0, the only supported [adaptive presentation styles] are UIModalPresentationFullScreen and UIModalPresentationOverFullScreen. */
    //so we are setting as none
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    static func configurePresentation(forController controller : UIViewController) -> UIPopoverPresentationController {
        
        controller.modalPresentationStyle = .popover
        let presentationController = controller.presentationController as! UIPopoverPresentationController
        presentationController.delegate = PKPopover.sharedInstance
        
        return presentationController
    }
    
}
