//
//  ProfileViewController.swift
//  iOS-Merchant
//
//  Created by Hsin Hwang on 2018/10/6.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    var department: CDepartment?
    var employee: Employee?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var tagStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(department!.departmentId)
        if department != nil {
            department!.showButtons(view: view, stackView: tagStackView, viewController: self)
        }
        if employee != nil {
            nameLabel.text = "\(employee!.name)"
            emailLabel.text = "\(employee!.email)"
            phoneLabel.text = "\(employee!.phone)"
            
        }
    }
    
    @objc func gotoCheckoutPage() {
        performSegue(withIdentifier: "toCheckoutView", sender: nil)
    }
    
    @objc func gotoTrafficPage() {
        print("go to checkout page")
    }
    
    @objc func gotoEventPage() {
        print("go to event page")
    }
    
    @objc func gotoFoodPage() {
        print("go to food page")
    }
    
    @objc func gotoCleanPage() {
        print("go to clean page")
    }
    
    @objc func gotoEditPage() {
        print("go to edit page")
    }
    
    @objc func gotoEmployeePage() {
        print("go to employee page")
    }
    
    @objc func gotoRoomPage() {
        print("go to room page")
    }
    
    @objc func gotoRoomViewPage() {
        print("go to room view page")
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
