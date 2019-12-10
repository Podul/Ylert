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
        view.backgroundColor = .green
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        present(TestViewController(), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
