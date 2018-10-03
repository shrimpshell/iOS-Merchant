//
//  ViewController.swift
//  iOS-Merchant
//
//  Created by Hsin Hwang on 2018/10/3.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func loginBtnPressed(_ sender: Any) {
        var username = usernameTF.text, password = passwordTF.text
        // 判斷員工帳號是否有效
        if username == "manager" && password == "1234" {
            performSegue(withIdentifier: "loginSuccessful", sender: nil)
            username = ""
            password = ""
            usernameTF.text = ""
            passwordTF.text = ""
        }
    }
    
    @IBAction func logout(_ segue: UIStoryboardSegue) {
    }
}

