//
//  HomeViewController.swift
//  Team1_QuizApp
//
//  Created by Nguyen Thi Huong on 9/3/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//
import UIKit
import FirebaseCore
import FirebaseDatabase
import GoogleSignIn

class HomeViewController: UIViewController {
    
    // Huong
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    @IBOutlet weak var lblEmail: UILabel!
    
    let cellID = "CategoryTableViewCell"
    
    var listCollection = [""]
    
    var collection = [Collection]()
    
    var ref = Database.database().reference()
    
    var spreadSheetId = "1urSOD9SR3lSD7WE1SF0CqKRa7c1INR9I-iMqQgwsKvM"
    
    var user = ""
    
    var tag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.title = "Subject Matter"
        
        if tag == 0 {
            lblEmail.text = "Name: \(user)"
        } else {
            lblEmail.text = "Email: \(user)"
        }
        
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
    
        GetListCategory()
        initComponent()
    }
    
    fileprivate func initComponent() {
        categoryTableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: cellID)
    }
    
    @IBAction func signOut(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
    }
    
    func GetListCategory(){
        self.listCollection.removeAll()
        ref.child(spreadSheetId).observe(.value, with: {
            snapshot in
            for category in snapshot.children {
                self.listCollection.append((category as AnyObject).key)
                print(self.listCollection.count)
            }
            
            self.categoryTableView.reloadData()
        })
    }    
}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listCollection.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CategoryTableViewCell
        cell.lblCategory.text = listCollection[indexPath.row]
        print("hihi")
        return cell
    }
}
