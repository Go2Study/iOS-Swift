//
//  GroupNameViewController.swift
//  Go2Study
//
//  Created by Ashish Kumar on 02/12/15.
//  Copyright © 2015 Go2Study. All rights reserved.
//

import UIKit

class GroupNameViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var buttonNext: UIBarButtonItem!
    @IBOutlet weak var textFieldName: UITextField!
    
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldName.delegate = self
        textFieldName.becomeFirstResponder()
        buttonNext.enabled = true
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "groupNameChooseMembers" {
            let viewController = segue.destinationViewController as! GroupMembersCreateViewController
            viewController.groupName = textFieldName.text!
        }
    }
    
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.text?.characters.count > 0 {
            textField.resignFirstResponder()
            performSegueWithIdentifier("groupNameChooseMembers", sender: self)
            return true
        }
        
        return false
    }
    
}
