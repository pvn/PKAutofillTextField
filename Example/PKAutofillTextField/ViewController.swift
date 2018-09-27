//
//  ViewController.swift
//  PKAutofillTextField
//
//  Created by pvn on 09/19/2018.
//  Copyright (c) 2018 pvn. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PKAutofillTextFieldDelegate {
    
    var textField: PKAutofillTextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.gray
        // Do any additional setup after loading the view, typically from a nib.
        
        // instantiate PKAutofillTextField
        // presenting: self
        // keyIdentifier: unique identifier for textfield
        // buttonTitle: to show the button title on textfield
        
        textField = PKAutofillTextField.init(frame: CGRect.init(x: 5, y: 400, width: 400, height: 50), presenting: self, keyIdentifier: "server", delegate: self, buttonTitle: "show")
        
        // some default values for textfield
        textField!.defaultValues(values: ["https://google.com", "https://weather.com"])
        
        // add textfield to view
        self.view.addSubview(textField!)
        
    }
    
    // PKAutofillTextFieldDelegate methods
    // callback methods after selecting value from lists
    func selectedValue(value: String) {
        // implementation goes here after selecting value from lists
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField!.resignFirstResponder()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

}

