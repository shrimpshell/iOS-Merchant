//
//  ProfileViewController.swift
//  iOS-Merchant
//
//  Created by Hsin Hwang on 2018/10/6.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    var employeeId: String?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var tagStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getEmployeeInfo()
    }

    func getEmployeeInfo() {
        switch employeeId {
        case "4":
            insertFrontDeskButtons()
        default:
            print("other employee")
        }
    }
    
    func insertFrontDeskButtons() {
        let checkout = UIImageView(frame: CGRect(x: 0, y: tagStackView.frame.maxY + 20, width: 100, height: 100))
        checkout.image = UIImage(named: "checkout.png")
        view.addSubview(checkout)
        let tabCheckout = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.gotoCheckoutPage))
        checkout.addGestureRecognizer(tabCheckout)
        checkout.isUserInteractionEnabled = true
        
        let traffic = UIImageView(frame: CGRect(x: checkout.frame.maxX, y: tagStackView.frame.maxY + 20, width: 100, height: 100))
        traffic.image = UIImage(named: "traffic.png")
        view.addSubview(traffic)
        let tabTraffic = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.gotoTrafficPage))
        traffic.addGestureRecognizer(tabTraffic)
        traffic.isUserInteractionEnabled = true
        
    }
    
    @objc func gotoCheckoutPage() {
        performSegue(withIdentifier: "toCheckoutView", sender: nil)
    }
    
    @objc func gotoTrafficPage() {
        print("go to checkout page")
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
