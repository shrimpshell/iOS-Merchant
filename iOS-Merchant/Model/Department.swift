//
//  Department.swift
//  iOS-Merchant
//
//  Created by Hsin Hwang on 2018/10/20.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit

protocol PDepartment {
    var departmentId: Int { get }
    func showButtons(view: UIView, stackView: UIStackView, viewController: UIViewController)
}

class CDepartment: PDepartment {
    var departmentId: Int
    
    func showButtons(view: UIView, stackView: UIStackView, viewController: UIViewController) {
        let edit = UIImageView(frame: CGRect(x: 0, y: stackView.frame.maxY + 20, width: 90, height: 90))
        createButton(imageBtn: edit, view: view, viewController: viewController, imageName: "edit.png", selector: #selector(ProfileViewController.gotoEditPage))
        
        switch self.departmentId {
        case 1:
            let clean = UIImageView(frame: CGRect(x: edit.frame.maxX, y: stackView.frame.maxY + 20, width: 90, height: 90))
            createButton(imageBtn: clean, view: view, viewController: viewController, imageName: "clean.png", selector: #selector(ProfileViewController.gotoCleanPage))
        case 2:
            let room = UIImageView(frame: CGRect(x: edit.frame.maxX, y: stackView.frame.maxY + 20, width: 90, height: 90))
            createButton(imageBtn: room, view: view, viewController: viewController, imageName: "room.png", selector: #selector(ProfileViewController.gotoRoomPage))
            
            let traffic = UIImageView(frame: CGRect(x: edit.frame.maxX, y: stackView.frame.maxY + 20, width: 90, height: 90))
            createButton(imageBtn: traffic, view: view, viewController: viewController, imageName: "traffic.png", selector: #selector(ProfileViewController.gotoTrafficPage))
        case 3:
            let food = UIImageView(frame: CGRect(x: edit.frame.maxX, y: stackView.frame.maxY + 20, width: 90, height: 90))
            createButton(imageBtn: food, view: view, viewController: viewController, imageName: "food.png", selector: #selector(ProfileViewController.gotoFoodPage))
        case 4:
            let checkout = UIImageView(frame: CGRect(x: edit.frame.maxX, y: stackView.frame.maxY + 20, width: 90, height: 90))
            createButton(imageBtn: checkout, view: view, viewController: viewController, imageName: "checkout.png", selector: #selector(ProfileViewController.gotoCheckoutPage))
            
            let room = UIImageView(frame: CGRect(x: checkout.frame.maxX, y: stackView.frame.maxY + 20, width: 90, height: 90))
            createButton(imageBtn: room, view: view, viewController: viewController, imageName: "room.png", selector: #selector(ProfileViewController.gotoRoomPage))
        case 5:
            let roomViews = UIImageView(frame: CGRect(x: edit.frame.maxX, y: stackView.frame.maxY + 20, width: 90, height: 90))
            createButton(imageBtn: roomViews, view: view, viewController: viewController, imageName: "room.png", selector: #selector(ProfileViewController.gotoRoomPage))
            
            let events = UIImageView(frame: CGRect(x: roomViews.frame.maxX, y: stackView.frame.maxY + 20, width: 90, height: 90))
            createButton(imageBtn: events, view: view, viewController: viewController, imageName: "event.png", selector: #selector(ProfileViewController.gotoEventPage))
            
            let employees = UIImageView(frame: CGRect(x: events.frame.maxX, y: stackView.frame.maxY + 20, width: 90, height: 90))
            createButton(imageBtn: employees, view: view, viewController: viewController, imageName: "employees.png", selector: #selector(ProfileViewController.gotoEmployeePage))
        default:
            break
        }
    }
    
    func createButton(imageBtn: UIImageView, view: UIView, viewController: UIViewController, imageName: String, selector: Selector) {
        imageBtn.image = UIImage(named: imageName)
        view.addSubview(imageBtn)
        let gestureRecognizer = UITapGestureRecognizer(target: viewController, action: selector)
        imageBtn.addGestureRecognizer(gestureRecognizer)
        imageBtn.isUserInteractionEnabled = true
    }
    
    init(departmentId: Int) {
        self.departmentId = departmentId
    }
}
