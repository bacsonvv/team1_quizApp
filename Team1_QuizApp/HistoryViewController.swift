//
//  HistoryViewController.swift
//  Team1_QuizApp
//
//  Created by Vuong Vu Bac Son on 9/7/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HistoryViewController: UIViewController {
    
    var userId = "123"
    var categroy = "Geography"
    
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageCategory: UIImageView!
    
    var ref: DatabaseReference!
    var listUser: [UserHistory] = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        lblUsername.text = userId
        lblCategory.text = categroy
        imageCategory.image = UIImage(named: categroy)

        tableView.register(HistoryViewCell.nib(), forCellReuseIdentifier: HistoryViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        getUserHistory()
    }
    
    func getUserHistory() {
        self.ref.child("PlayHistory").child(userId).child(categroy).observeSingleEvent(of: .value) { snapshot in
            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String:Any] else {
                    print("Error")
                    return
                }
                
                let score = dict["score"] as! Int
                let time = dict["time"] as! Int
                
                let user = UserHistory(score: score, time: time)
                self.listUser.append(user)
            }
        }
    }
}

struct UserHistory {
    var score: Int
    var time: Int
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryViewCell.identifier, for: indexPath) as! HistoryViewCell
        cell.configure(numberOfQuiz: indexPath.row + 1, score: self.listUser[indexPath.row].score, time: self.listUser[indexPath.row].time)
        
        return cell
    }
}
