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

    var listUser = [User]() 
        var userHistory = "Thanh"

        
        var spreadSheetId = "Users"
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            ref = Database.database().reference()
        tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        getData()
        getUser()
        
        
        
//            getData()
        }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(listUser.count)
    
        return listUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        cell.load( score: listUser[indexPath.row].score, category: listUser[indexPath.row].category)
        
        
        
        return cell
    }
    
//        func getData(){
//            self.ref.child(self.spreadSheetId).child("History").observeSingleEvent(of: .value) { snapshot in
//                for case let child as DataSnapshot in snapshot.children {
//                    guard let dict = child.value as? [String:Any] else {
//                        print("Error")
//                        return
//                    }
//                    let question = dict["Question"] as! String
//                    let answer = dict["Answer"] as! String
//                    let choice1 = dict["Choice1"] as! String
//                    let choice2 = dict["Choice2"] as! String
//                    let choice3 = dict["Choice3"] as! String
//                    let choice4 = dict["Choice4"] as! String
//
//                    let id = dict["Id"] as! Int
//                    let q = Question(Answer: answer, Choice1: choice1, Choice2: choice2, Choice3: choice3, Choice4: choice4, Id: id, Question: question)
//                    print(q)
//                    self.listQuestion.append(q)
//                }
//            }
//        }
            func getData(){
                self.ref.child(self.spreadSheetId).child(userHistory).observeSingleEvent(of: .value) { snapshot in
                    for case let child as DataSnapshot in snapshot.children {
                        guard let dict = child.value as? [String:Any] else {
                            print("Error")
                            return
                        }
                        
                    
                        
                        let score = dict["score"] as! Int
    
                        let category = dict["category"] as! String
                        let q = User(category: category, score: score)
                        print("day la\(q)")
                        self.listUser.append(q)
//                        self.tableView.reloadData()
                     
                    }
                }
            }
    func getUser() {
        lblUser.text = userHistory
    }
    
    
    }




