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
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var lblLoading: UILabel!
    
    var userId = ""
    var category = "Geography"
    var ref: DatabaseReference!
    var listUser: [UserHistory] = []
    var listUserForView: [UserHistory] = [UserHistory(score: 0, time: 0, playDate: "")]
    var timer = Timer()
    var loadingTime = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        tableView.register(HistoryViewCell.nib(), forCellReuseIdentifier: HistoryViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.title = category
        
        loading.isHidden = false
        lblLoading.isHidden = false
        loading.startAnimating()
        setStateForView(state: true)
        
        DispatchQueue.main.async {
            self.getUserHistory()
        }
        
        checkWhenDataIsReady()
        
        tableView.reloadData()
    }
    
    func checkWhenDataIsReady() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(HistoryViewController.finishLoading)), userInfo: nil, repeats: true)
    }
    
    @objc func finishLoading() {
        loadingTime += 1
        
        if loadingTime == 5 {
            lblLoading.text = "No data to show."
            loading.isHidden = true
            loading.stopAnimating()
        }
        
        if listUser.count != 0 {
            loading.isHidden = true
            lblLoading.isHidden = true
            loading.stopAnimating()
            
            listUserForView.removeAll()
            listUserForView = listUser
            
            setStateForView(state: false)
            
            tableView.reloadData()
            
            timer.invalidate()
        }
    }
    
    func setStateForView(state: Bool) {
        tableView.isHidden = state
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
    
    @IBAction func backToSetting(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(listUser.count)
        return listUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryViewCell.identifier, for: indexPath) as! HistoryViewCell
        cell.configure(score: self.listUser[indexPath.row].score, time: self.listUser[indexPath.row].time, playDate: self.listUser[indexPath.row].playDate)
        
        return cell
    }

}
