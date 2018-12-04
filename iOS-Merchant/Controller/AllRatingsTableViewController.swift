//
//  AllRatingsTableViewController.swift
//  iOS-Merchant
//
//  Created by Una Lee on 2018/11/27.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit

class AllRatingsTableViewController: UITableViewController {
    
    var refreshAction = UIRefreshControl()
    var allRatingItems = [Rating]()
    let ratingAuth = Common.shared
    
    
    @IBOutlet var allRatingsTableView: UITableView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet var allRatingsListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshRatings()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "最新評價"
        showAllCustomerRatings(key: "getAll")
    }
    
    //下拉轉圈圈更新
    func refreshRatings() {
        refreshAction.addTarget(self, action: #selector(AllRatingsTableViewController.pullToRefresh), for: .valueChanged)
        refreshAction.attributedTitle = NSAttributedString(string: "刷新評論")
        allRatingsListView.refreshControl = refreshAction
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRatingItems.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allRatingCell", for: indexPath) as! AllRatingsUITableViewCell

        let allRating = allRatingItems[indexPath.row]
        cell.allRating = allRating

        return cell
    }
   
    //變更評論排列方式
    @IBAction func changeSearchBtnPressered(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: "排序方式", preferredStyle: .actionSheet)
        
        let firstBtn = UIAlertAction(title: "最新評價", style: .default) {
            (action) in
            self.navigationItem.title = "最新評價"
            self.showAllCustomerRatings(key: "getAll")
        }
        
        let secondBtn = UIAlertAction(title: "尚未回覆留言", style: .default){
            (action) in
            self.navigationItem.title = "尚未回覆留言"
            self.showAllCustomerRatings(key: "getAllByRatingStatus")
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel)
        
        alert.addAction(firstBtn)
        alert.addAction(secondBtn)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func showAllCustomerRatings(key: String) {
        ratingAuth.getAllCustomerRatings(key: key) { (result, error) in
            if let error = error {
                printHelper.println(tag: "AllRatingsTableViewController", line: #line, "Rating download error\(error)")
                return
            }
            guard let result = result else {
                printHelper.println(tag: "AllRatingsTableViewController", line: #line, "result is nil.")
                return
            }
            print("Retrive all ratings list is OK.")
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                else  {
                    printHelper.println(tag: "AllRatingsTableViewController", line: #line, "Fail to generate jsonData.")
                    return
            }
            let decoder = JSONDecoder()
            guard let resultObject = try? decoder.decode([Rating].self, from: jsonData) else {
                printHelper.println(tag: "AllRatingsTableViewController", line: #line, "Fail to decoder jsonData.")
                return
            }
            printHelper.println(tag: "AllRatingsTableViewController", line: #line, "resultObject: \(resultObject)")
            self.allRatingItems = resultObject
            
            //更新TableView內容
            self.tableView.reloadData()
            
            //讓轉圈圈消失
            self.refreshAction.endRefreshing()
        }
    }

    @objc
    func pullToRefresh() {
        self.navigationItem.title = "最新評價"
        showAllCustomerRatings(key:"getAll")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResponseRatingView" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let rating = allRatingItems[indexPath.row]
                let controller = segue.destination as!  ResponseRatingViewController
                controller.rating = rating
               
            }
        }
    }
    
    @IBAction func unwindToAllRatingsTablePage(_ segue: UIStoryboardSegue){
        
    }
}
