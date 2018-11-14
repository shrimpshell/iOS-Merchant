//
//  ProfileViewController.swift
//  iOS-Merchant
//
//  Created by Hsin Hwang on 2018/10/6.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit
import PromiseKit

class ProfileViewController: UIViewController {
    var department: CDepartment?
    var employee: Employee?
    var rooms = [OrderRoomDetail]()
    var instants = [OrderInstantDetail]()
    var reservation = [Reservation]()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var tagStackView: UIStackView!
    @IBOutlet weak var employeeImageView: UIImageView!
    
    
    // MARL: - override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        if department != nil {
            department!.showButtons(view: view, stackView: tagStackView, viewController: self)
        }
        if employee != nil {
            self.nameLabel.text = "\(self.employee!.name)"
            self.emailLabel.text = "\(self.employee!.email)"
            self.phoneLabel.text = "\(self.employee!.phone)"
        }
        
        showDepartmentButtons()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if department?.departmentId == 4 && segue.identifier == "toCheckoutView" {
            let checkoutTableView = segue.destination as? CheckoutTableViewController
            checkoutTableView?.reservation = self.reservation
        }
    }
    
    // MARK: - custome functions
    private func refactorData() {
        // 重構結構
        for checkout in rooms {
            reservation.append(Reservation(id: checkout.roomGroup, checkout: [], instant: []))
        }
        reservation = reservation.removeDeuplicates()
        for (index, _) in reservation.enumerated() {
            for checkout in rooms {
                if checkout.roomGroup == reservation[index].id {
                    reservation[index].checkout.append(checkout)
                }
            }
            for instant in instants {
                if instant.roomGroup == reservation[index].id {
                    reservation[index].instant.append(instant)
                }
            }
        }
        reservation = reservation.sorted(by: {(first,next) in
            return Int(first.checkout[0].roomReservationStatus)! < Int(next.checkout[0].roomReservationStatus)!
        })
    }
    
    private func showDepartmentButtons() {
        switch department?.departmentId {
        case 5:
            break
        case 4:
            let payment: OrderPaymentDeatil = OrderPaymentDeatil()
            let roomParams: [String: String] = ["action" : "viewRoomPayDetailByEmployee"]
            let instantParams: [String: String] = ["action" : "viewInstantPayDetailByEmployee"]
            
            payment.viewRoomPayDetailByEmployee(roomParams).then { (ords) -> Promise<[OrderInstantDetail]> in
                self.rooms = ords
                return payment.viewInstantPayDetailByEmployee(instantParams)
            }.then { (oids) -> Promise<Data?> in
                self.instants = oids
                self.refactorData()
                let employeeAuth: EmployeeAuth = EmployeeAuth()
                let imageParams: [String : Any] = ["action":"getImage", "IdEmployee":self.employee!.id]
                return employeeAuth.getEmployeeImage(imageParams)
            }.done { (data) in
                if (data?.count)! > 0 {
                    DispatchQueue.main.async() {
                        self.employeeImageView.image = UIImage(data: data!)
                    }
                }
            }.catch { (error) in
                assertionFailure("CheckoutTableViewController Error: \(error)")
            }
            break
        case 3:
            break
        case 2:
            break
        case 1:
            break
        default:
            print("No department found")
        }
    }
    
    
    // MARL: - @objc page direction
    @objc func gotoCheckoutPage() {
        performSegue(withIdentifier: "toCheckoutView", sender: nil)
    }
    
    @objc func gotoTrafficPage() {
        print("go to traffic page")
    }
    
    @objc func gotoEventPage() {
        print("go to event page")
        if let controller = storyboard?.instantiateViewController(withIdentifier: "EventView"){
//            present(controller, animated: true, completion: nil)
            navigationController?.pushViewController(controller, animated: true)
        }
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
        if let controller = storyboard?.instantiateViewController(withIdentifier: "RoomView"){
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc func gotoRoomViewPage() {
        print("go to room view page")
    }

}

extension Array where Element: Equatable {
    func removeDeuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        return result
    }
}
