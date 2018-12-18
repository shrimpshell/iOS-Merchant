//
//  ViewController.swift
//  iOS-Merchant
//
//  Created by Hsin Hwang on 2018/10/3.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit
import PromiseKit

class ViewController: UIViewController {
    var departmentId: Int = 0
    var employee: Employee?

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func loginBtnPressed(_ sender: UIButton) {
        let employeeTask = EmployeeAuth()
        
        var email: String = usernameTF.text!, password: String = passwordTF.text!
        guard email.count != 0 && password.count != 0 else {
            let alertController = UIAlertController(title: "帳號資料空白", message:
                "帳號或密碼不可留空", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
        // 判斷員工帳號是否有效
        
        let employeeValid = ["action": "employeeValid", "email": email, "password": password] as [String : String]
        
        employeeTask.isCorrectUser(employeeValid).then { (employeeId) -> Promise<Employee?> in
            let employeeProfile = ["action": "findById", "idEmployee": employeeId] as [String : String]
            guard employeeId.count > 0 || employeeId != "0" || (Int(employeeId) != nil)  else {
                return employeeTask.getEmployeeInfo(["action": "findById", "idEmployee": ""])
            }
            return employeeTask.getEmployeeInfo(employeeProfile)
        }.done { (employee) in
            if employee == nil {
//                assertionFailure("employee information is nil")
                let alertController = UIAlertController(title: "帳號資料錯誤", message:
                    "帳號或密碼不正確", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            self.employee = employee
            self.departmentId = employee!.departmentId
            email = ""
            password = ""
            self.usernameTF.text = ""
            self.passwordTF.text = ""
            self.performSegue(withIdentifier: "loginSuccessful", sender: nil)
        }.catch { (error) in
            let alertController = UIAlertController(title: "錯誤", message:
                (error as! String), preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navVC = segue.destination as? UINavigationController
        let controller = navVC?.viewControllers.first as! ProfileViewController
        controller.employee = employee
        controller.department = CDepartment(departmentId: departmentId)
    }
    
    @IBAction func logout(_ segue: UIStoryboardSegue) {
    }
}

