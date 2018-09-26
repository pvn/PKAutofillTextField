//
//  PKAutofillTextField.swift
//  PKAutofillTextField_Example
//
//  Created by Praveen Kumar Shrivastava on 19/09/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

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
