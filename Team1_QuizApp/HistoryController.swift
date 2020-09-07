//
//  ViewController.swift
//  TracNhiemCauHoi1
//
//  Created by Van Thanh on 9/4/20.
//  Copyright © 2020 Van Thanh. All rights reserved.
//

import UIKit
    
import FirebaseDatabase
import FirebaseAnalytics

class HistoryController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
        
    
    @IBOutlet weak var lblUser: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    var ref : DatabaseReference!

   var listUser: [User] = []{
        didSet{
            
            print(listUser.count)
            tableView.reloadData()
        }
    }
        var userHistory = "123"
        var spreadSheetId = "PlayHistory"
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            ref = Database.database().reference()
        tableView.register(UINib(nibName: "HistoryCell", bundle: nil), forCellReuseIdentifier: "HistoryCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        getData()
        getUser()
        
        
        
//            getData()
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(listUser.count)
     return listUser.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        cell.load( score: listUser[indexPath.row].score, time: listUser[indexPath.row].time)
        
        
        
        return cell
    }
    

            func getData(){
                self.ref.child(self.spreadSheetId).child(userHistory).child("Geography").observeSingleEvent(of: .value) { snapshot in
                    for case let child as DataSnapshot in snapshot.children {
                        guard let dict = child.value as? [String:Any] else {
                            print("Error")
                            return
                        }
                        let score = dict["score"] as! Int
    
                        let time = dict["time"] as! Int
                        let q = User(time: time, score: score)
                        print("day la\(q)")
                        self.listUser.append(q)
                       // self.tableView.reloadData()
                     
                    }
                }
            }
    
    func getUser() {
        lblUser.text = userHistory
    }
    
    
    }




