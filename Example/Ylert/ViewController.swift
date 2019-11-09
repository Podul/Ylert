//
//  ViewController.swift
//  Ylert
//
//  Created by Podul on 11/09/2019.
//  Copyright (c) 2019 Podul. All rights reserved.
//

import UIKit
import Ylert

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        UIAlertController
            .actionSheet()
            .title("title")
            .message("message")
            .destructive("Destructive")
            .cancel("Cancel") { _ in
                print("touched cancel")
        }
        .default("Default")
        .show()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
