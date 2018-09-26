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
    

    var textField: PKAutofillTextField? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.gray
        // Do any additional setup after loading the view, typically from a nib.
        
        textField = PKAutofillTextField.init(frame: CGRect.init(x: 175, y: 400, width: 175, height: 50), presenting: self, keyIdentifier: "server", delegate: self)
        textField?.backgroundColor = UIColor.white
        textField?.setButtonImage(imageName: "pk.png")
        self.view.addSubview(textField!)
        
        let tempTextField = UITextField.init(frame: CGRect.init(x: 50, y: 600, width: 200, height: 50))
        tempTextField.backgroundColor = UIColor.white
        self.view.addSubview(tempTextField)
        
        let submitButton = UIButton.init(frame: CGRect.init(x: 50, y: 700, width: 250, height: 50))
        submitButton.setTitle("Submit", for: .normal)
        submitButton.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
        self.view.addSubview(submitButton)
        
        
    }
    
    @objc func buttonClicked() {
        
        let tempViewController = UIViewController.init()
//        self.navigationController?.pushViewController(tempViewController, animated: true)
        self.present(tempViewController, animated: true, completion: nil)
        print("textfield value \(textField?.text)")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

}

