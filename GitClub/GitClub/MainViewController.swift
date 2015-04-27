//
//  ViewController.swift
//  GitClub
//
//  Created by Vitor Kawai Sala on 27/04/15.
//  Copyright (c) 2015 Wololo. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var user: UITextField?
        
        var alertController = UIAlertController(title: "Teste", message: "Oi Tudo bem?", preferredStyle: .Alert)
        
        let buttonOk: UIAlertAction = UIAlertAction(title: "OK", style: .Default) { (UIAlertAction) -> Void in
            println("User: \(user?.text)")
        }
        
        let buttonCancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { (UIAlertAction) -> Void in}
        
        alertController.addAction(buttonOk)
        alertController.addAction(buttonCancel)
        
        alertController.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
            textField.placeholder = "User"
            user = textField
        }
        
        self.presentViewController (alertController, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

