//
//  ProfileEditViewController.swift
//  iOS-Merchant
//
//  Created by Hsin Hwang on 2018/11/30.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit

class ProfileEditViewController: UIViewController {
    var employee: Employee?

    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var department: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let employee = employee else {
            return
        }
        
        showEmployeeInfo(id: employee.id, name: employee.name, password: employee.password, email: employee.email, gender: employee.gender, phone: employee.phone, address: employee.address, departmentId: employee.departmentId)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func showEmployeeInfo(id: Int, name: String, password: String, email: String, gender: String, phone: String, address: String, departmentId: Int) {
        self.id.text = id == 0 ? "" : "員工編號：\(id)"
        self.name.text = "員工姓名：\(name)"
        self.gender.text = gender == "MALE" ? "員工性別：男" : "員工性別：女"
        self.email.text = "員工郵件：\(email)"
        switch departmentId {
        case 5:
            self.department.text = "員工部門：主管部門"
        case 4:
            self.department.text = "員工部門：櫃檯部門"
        case 3:
            self.department.text = "員工部門：餐飲部門"
        case 2:
            self.department.text = "員工部門：房務部門"
        case 1:
            self.department.text = "員工部門：房務部門"
        default:
            self.department.text = ""
        }
        self.password.text = password
        self.phone.text = phone
        self.address.text = address
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        submitButton.isEnabled = false
        guard let employee = employee else {
            return
        }
        
        let employeeTask = EmployeeAuth()
        var newEmployee = employee
        newEmployee.address = address.text!
        newEmployee.phone = phone.text!
        newEmployee.password = password.text!
        let employeeData = try! JSONEncoder().encode(newEmployee)
        let employeeString = String(data: employeeData, encoding: .utf8)
        let employeeParams = ["action":"updateWithoutImage", "employee":employeeString as Any] as [String : Any]
        
        employeeTask.updateEmployeeInfo(employeeParams).done {
            (result) in
            if result == "1" {
                self.submitButton.isEnabled = true
                self.showEmployeeInfo(id: 0, name: "", password: "", email: "", gender: "", phone: "", address: "", departmentId: 0)
                let alertController = UIAlertController(title: "更新成功", message:
                    "更新完成", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default,handler: nil))
                self.present(alertController, animated: true, completion: {
                    self.showEmployeeInfo(id: newEmployee.id, name: newEmployee.name, password: newEmployee.password, email: newEmployee.email, gender: newEmployee.gender, phone: newEmployee.phone, address: newEmployee.address, departmentId: newEmployee.departmentId)
                })
                
            }
        }
    }
    
}
