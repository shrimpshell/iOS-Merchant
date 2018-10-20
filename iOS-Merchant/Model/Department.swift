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
        edit.image = UIImage(named: "edit.png")
        view.addSubview(edit)
        let tabEdit = UITapGestureRecognizer(target: viewController, action: #selector(ProfileViewController.gotoEditPage))
        edit.addGestureRecognizer(tabEdit)
        edit.isUserInteractionEnabled = true
        switch self.departmentId {
        case 1:
            let clean = UIImageView(frame: CGRect(x: edit.frame.maxX, y: stackView.frame.maxY + 20, width: 90, height: 90))
            clean.image = UIImage(named: "clean.png")
            view.addSubview(clean)
            let tabClean = UITapGestureRecognizer(target: viewController, action: #selector(ProfileViewController.gotoCleanPage))
            clean.addGestureRecognizer(tabClean)
            clean.isUserInteractionEnabled = true
        case 2:
            let room = UIImageView(frame: CGRect(x: edit.frame.maxX, y: stackView.frame.maxY + 20, width: 90, height: 90))
            room.image = UIImage(named: "room.png")
            view.addSubview(room)
            let tabRoom = UITapGestureRecognizer(target: viewController, action: #selector(ProfileViewController.gotoRoomPage))
            room.addGestureRecognizer(tabRoom)
            room.isUserInteractionEnabled = true
        case 3:
            let food = UIImageView(frame: CGRect(x: edit.frame.maxX, y: stackView.frame.maxY + 20, width: 90, height: 90))
            food.image = UIImage(named: "food.png")
            view.addSubview(food)
            let tabFood = UITapGestureRecognizer(target: viewController, action: #selector(ProfileViewController.gotoFoodPage))
            food.addGestureRecognizer(tabFood)
            food.isUserInteractionEnabled = true
        case 4:
            let checkout = UIImageView(frame: CGRect(x: edit.frame.maxX, y: stackView.frame.maxY + 20, width: 90, height: 90))
            checkout.image = UIImage(named: "checkout.png")
            view.addSubview(checkout)
            let tabCheckout = UITapGestureRecognizer(target: viewController, action: #selector(ProfileViewController.gotoCheckoutPage))
            checkout.addGestureRecognizer(tabCheckout)
            checkout.isUserInteractionEnabled = true
            
            let traffic = UIImageView(frame: CGRect(x: checkout.frame.maxX, y: stackView.frame.maxY + 20, width: 90, height: 90))
            traffic.image = UIImage(named: "traffic.png")
            view.addSubview(traffic)
            let tabTraffic = UITapGestureRecognizer(target: viewController, action: #selector(ProfileViewController.gotoTrafficPage))
            traffic.addGestureRecognizer(tabTraffic)
            traffic.isUserInteractionEnabled = true
        default:
            let roomViews = UIImageView(frame: CGRect(x: edit.frame.maxX, y: stackView.frame.maxY + 20, width: 90, height: 90))
            roomViews.image = UIImage(named: "room.png")
            view.addSubview(roomViews)
            let tabRoom = UITapGestureRecognizer(target: viewController, action: #selector(ProfileViewController.gotoRoomPage))
            roomViews.addGestureRecognizer(tabRoom)
            roomViews.isUserInteractionEnabled = true
            
            let events = UIImageView(frame: CGRect(x: roomViews.frame.maxX, y: stackView.frame.maxY + 20, width: 90, height: 90))
            events.image = UIImage(named: "event.png")
            view.addSubview(events)
            let tabEvent = UITapGestureRecognizer(target: viewController, action: #selector(ProfileViewController.gotoEventPage))
            events.addGestureRecognizer(tabEvent)
            events.isUserInteractionEnabled = true
            
            let employees = UIImageView(frame: CGRect(x: events.frame.maxX, y: stackView.frame.maxY + 20, width: 90, height: 90))
            employees.image = UIImage(named: "employees.png")
            view.addSubview(employees)
            let tabEmployee = UITapGestureRecognizer(target: viewController, action: #selector(ProfileViewController.gotoEmployeePage))
            employees.addGestureRecognizer(tabEmployee)
            employees.isUserInteractionEnabled = true
        }
    }
    
    init(departmentId: Int) {
        self.departmentId = departmentId
    }
}
