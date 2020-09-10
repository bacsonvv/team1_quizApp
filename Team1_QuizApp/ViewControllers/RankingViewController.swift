//
//  RankingViewController.swift
//  Team1_QuizApp
//
//  Created by Vuong Vu Bac Son on 9/9/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RankingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var lblLoading: UILabel!
    
    var category = "History"
    var ref: DatabaseReference!
    var timer = Timer()
    var listRanking: [UserRank] = []
    var listRankingForView: [UserRank] = [UserRank(key: "Default", score: 0, time: 0)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarItem.tag = TabbarItemTag.fourthViewConroller.rawValue
        
        ref = Database.database().reference()
        
        let nib = UINib(nibName: "RankingHeaderView", bundle: nil)
        tableView.register(RankViewCell.nib(), forCellReuseIdentifier: RankViewCell.identifier)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "rankingHeaderView")
        tableView.delegate = self
        tableView.dataSource = self
        
        loading.isHidden = false
        loading.startAnimating()
        lblLoading.isHidden = false
        
        setStateForView(state: true)
        
        DispatchQueue.main.async {
            self.getListUser()
        }
        
        checkWhenDataIsReady()
        
        tableView.reloadData()
    }
    
    func setStateForView(state: Bool) {
        tableView.isHidden = state
    }
    
    func checkWhenDataIsReady() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(RankingViewController.setupData)), userInfo: nil, repeats: true)
    }
    @objc func setupData() {
        if listRanking.count != 0 {
            loading.isHidden = true
            loading.stopAnimating()
            lblLoading.isHidden = true
            setStateForView(state: false)
            
            self.listRanking.sort(by: {$0.score > $1.score})
            
            listRankingForView.removeAll()
            listRankingForView = listRanking
            
            tableView.reloadData()
            
            timer.invalidate()
        }
    }
    
    func getListUser(){
        ref.child("PlayHistory").observeSingleEvent(of: .value, with: {
            snapshot in
            for category in snapshot.children {
                let q = UserRank(key: (category as AnyObject).key)
                self.getDataRank(user: q.key)
            }
        })
    }
    
    func getDataRank(user: String){
        self.ref.child("PlayHistory").child(user).child(category).queryOrdered(byChild: "score").queryLimited(toLast: 1).observe(.value) { snapshot in
            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String:Any] else {
                    return
                }
                
                let score = dict["score"] as! Int
                let time = dict["time"] as! Int
                
                let q = UserRank(key: user,score: score, time: time)
                self.listRanking.append(q)
            }
        }
    }
}

extension RankingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listRankingForView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RankViewCell.identifier, for: indexPath) as! RankViewCell
        
        var imageName = ""
        if indexPath.row == 0 {
            imageName = "1stplace"
        } else if indexPath.row == 1 {
            imageName = "2ndplace"
        } else if indexPath.row == 2 {
            imageName = "3rdplace"
        }
        
        cell.configure(imageName: imageName, score: listRankingForView[indexPath.row].score, time: listRankingForView[indexPath.row].time)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "rankingHeaderView") as! RankingHeaderView
        
        return header
    }
}
