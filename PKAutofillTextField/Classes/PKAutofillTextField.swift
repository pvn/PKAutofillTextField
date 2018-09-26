//
//  PKAutofillTextField.swift
//  PKAutofillTextField_Example
//
//  Created by Praveen Kumar Shrivastava on 19/09/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

enum AutoFillTextFieldError: Error {
    case keyMissing
    case outOfStock
}

public protocol PKAutofillTextFieldDelegate: class {
    
    func selectedValue(value: String)
}

@IBDesignable
open class PKAutofillTextField: UITextField {
    
    var keyIdentifier = ""
    var listVC: PKAutoListViewController?
    var presentingVC: UIViewController?
    weak var autofillTextFieldDelegate: PKAutofillTextFieldDelegate?
    
    var showButton = UIButton(type: .custom)
    var values = Set<String>()
    
    required public init(frame: CGRect, presenting: UIViewController, keyIdentifier: String, delegate: PKAutofillTextFieldDelegate) {
        
        super.init(frame: frame)
        
        //UITextField delegate
        self.delegate = self
        
        //PKAutofillTextField delegate
        self.autofillTextFieldDelegate = delegate
        
        self.presentingVC = presenting
        self.keyIdentifier = keyIdentifier
        
        self.listVC = PKAutoListViewController.init(delegate: self)
        
        showButton.titleLabel?.text = "Show"
        showButton.titleLabel?.textColor = UIColor.black
        showButton.setTitle("show", for: .normal)

        showButton.frame = CGRect(x: 0, y: 0, width: CGFloat(25), height: CGFloat(25))
        showButton.addTarget(self, action: #selector(self.refresh), for: .touchUpInside)
        self.rightView = showButton
        self.rightViewMode = .whileEditing
    }
    
    public func setButtonImage(imageName: String) {
        showButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    @IBAction func refresh(_ sender: Any) {
        let items = datasource()
        print("items \(items)")
        if (items.count > 0) {
            displayItems()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PKAutofillTextField: PKAutoListViewControllerDelegate {
    
    public func selectedValue(value: String) {
        self.listVC?.dismiss(animated: true, completion: nil)
        self.autofillTextFieldDelegate?.selectedValue(value: value)
    }
    
    public func removeItem(value: String) {
        PKDataManager.remove(value, forKey: self.keyIdentifier)
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
