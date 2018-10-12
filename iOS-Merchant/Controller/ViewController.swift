//
//  ViewController.swift
//  iOS-Merchant
//
//  Created by Hsin Hwang on 2018/10/3.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var employeeId: String = "5"

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func loginBtnPressed(_ sender: UIButton) {
        var username = usernameTF.text, password = passwordTF.text
        guard username?.count != 0 && password?.count != 0 else {
            let alertController = UIAlertController(title: "帳號資料空白", message:
                "帳號或密碼不可留空", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
        // 判斷員工帳號是否有效
        let isEmployee = username == "manager" && password == "1234" ||
            username == "clean" && password == "1234" ||
            username == "dining" && password == "1234" ||
            username == "room" && password == "1234" ||
            username == "front" && password == "1234"
        // 登入後員工編號要撈出來
        employeeId = "4"
        
        guard isEmployee else {
            let alertController = UIAlertController(title: "帳號資料錯誤", message:
                "帳號或密碼不正確", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        performSegue(withIdentifier: "loginSuccessful", sender: nil)
        username = ""
        password = ""
        usernameTF.text = ""
        passwordTF.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navVC = segue.destination as? UINavigationController
        let controller = navVC?.viewControllers.first as! ProfileViewController
        controller.employeeId = employeeId
    }
    
    @IBAction func logout(_ segue: UIStoryboardSegue) {
    }
}

