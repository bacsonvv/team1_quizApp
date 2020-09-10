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
    
    @IBOutlet weak var tableView: UITableView!
    
    var userId = ""
    var category = "Geography"
    var ref: DatabaseReference!
    var listUser: [UserHistory] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        tableView.register(HistoryViewCell.nib(), forCellReuseIdentifier: HistoryViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.title = category
        
        getUserHistory()
    }
    
    func getUserHistory() {
        self.ref.child("PlayHistory").child(userId).child(category).observeSingleEvent(of: .value) { snapshot in
            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String:Any] else {
                    print("Error")
                    return
                }
                
                let score = dict["score"] as! Int
                let time = dict["time"] as! Int
                let playDate = dict["playDate"] as! String
                
                let user = UserHistory(score: score, time: time, playDate: playDate)
                self.listUser.append(user)
            }
        }
    }
    
    @IBAction func backToHome(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "tabBarVC")
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryViewCell.identifier, for: indexPath) as! HistoryViewCell
        cell.configure(score: self.listUser[indexPath.row].score, time: self.listUser[indexPath.row].time, playDate: self.listUser[indexPath.row].playDate)
        
        return cell
    }

}
