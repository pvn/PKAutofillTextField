//
//  ViewController.swift
//  PKAutofillTextField
//
//  Created by pvn on 09/19/2018.
//  Copyright (c) 2018 pvn. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PKAutofillTextFieldDelegate {
    
    func selectedValue(value: String) {
        print("Selected value: \(value)")
    }
    
    var textField: PKAutofillTextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.gray
        // Do any additional setup after loading the view, typically from a nib.
        
        textField = PKAutofillTextField.init(frame: CGRect.init(x: 5, y: 400, width: 400, height: 50), presenting: self, keyIdentifier: "server", delegate: self, buttonTitle: "show")
        textField!.defaultValues(values: ["http://10.0.0.0", "http://10.0.0.1", "http://10.0.0.2", "http://10.0.0.3"])
        self.view.addSubview(textField!)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField!.resignFirstResponder()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

}

