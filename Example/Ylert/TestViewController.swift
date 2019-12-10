//
//  TestViewController.swift
//  Ylert_Example
//
//  Created by Podul on 2019/12/10.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    deinit {
        print("TestViewController is deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        // Do any additional setup after loading the view.
        
        UIAlertController
            .actionSheet()
            .title("title")
            .message("message")
            .destructive("Destructive")
            .cancel("Cancel") { _ in
                self.view.backgroundColor = .white
                print("touched cancel")
        }
        .default("Default")
        .show()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true) {
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
