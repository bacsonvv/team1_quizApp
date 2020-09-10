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
    
    @IBOutlet weak var civicEducationView: UIView!
    @IBOutlet weak var geographyView: UIView!
    @IBOutlet weak var historyView: UIView!
    
    var ref: DatabaseReference!
    var timer = Timer()
    var listRanking: [UserRank] = []
    var listRankingForView: [UserRank] = [UserRank(key: "Default", score: 0, time: 0, username: "Default")]
    var category = "Civic Education"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarItem.tag = TabbarItemTag.fourthViewConroller.rawValue
        
        ref = Database.database().reference()
        
        let civicEducationGesture = UITapGestureRecognizer(target: self, action:  #selector(self.civicEducationClicked))
        self.civicEducationView.addGestureRecognizer(civicEducationGesture)
        
        let geographyGesture = UITapGestureRecognizer(target: self, action:  #selector(self.geographyClicked))
        self.geographyView.addGestureRecognizer(geographyGesture)
        
        let historyGesture = UITapGestureRecognizer(target: self, action:  #selector(self.historyClicked))
        self.historyView.addGestureRecognizer(historyGesture)

        tableView.register(RankViewCell.nib(), forCellReuseIdentifier: RankViewCell.identifier)

        tableView.delegate = self
        tableView.dataSource = self
        
        setupViewBorder(view: civicEducationView)
        setupViewBorder(view: geographyView)
        setupViewBorder(view: historyView)
        
        civicEducationView.backgroundColor = .red
        
        DispatchQueue.main.async {
            self.getListUser(category: self.category)
        }
        
        checkWhenDataIsReady()
        
        tableView.reloadData()
    }
    
    func initTableView() {
        loading.isHidden = false
        loading.startAnimating()
        lblLoading.isHidden = false
        
        setStateForView(state: true)
        
        DispatchQueue.main.async {
            self.getListUser(category: self.category)
        }
        
        checkWhenDataIsReady()
        
    }
    
    func setupViewBorder(view: UIView) {
        view.layer.cornerRadius = 15
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.clipsToBounds = true
    }
    
    @objc func civicEducationClicked(sender : UITapGestureRecognizer) {
        listRanking.removeAll()
        
        civicEducationView.backgroundColor = .red
        geographyView.backgroundColor = .white
        historyView.backgroundColor = .white
        
        self.category = "Civic Education"
        
        initTableView()

    }
    
    @objc func geographyClicked(sender : UITapGestureRecognizer) {
        listRanking.removeAll()
        
        geographyView.backgroundColor = .red
        historyView.backgroundColor = .white
        civicEducationView.backgroundColor = .white

        
        self.category = "Geography"
        
        initTableView()
    }
    
    @objc func historyClicked(sender : UITapGestureRecognizer) {
        listRanking.removeAll()
        
        historyView.backgroundColor = .red
        civicEducationView.backgroundColor = .white
        geographyView.backgroundColor = .white
        
        loading.isHidden = false
        loading.startAnimating()
        lblLoading.isHidden = false
        
        setStateForView(state: true)
        
        self.category = "History"
        
        DispatchQueue.main.async {
            self.getListUser(category: self.category)
        }
        
        checkWhenDataIsReady()
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
            
            self.listRanking = self.listRanking.sorted{
                a1, a2 in
                return (a1.score, a2.time) > (a2.score, a1.time)
            }
            
            listRankingForView.removeAll()
            listRankingForView = listRanking
            
            tableView.reloadData()
            
            timer.invalidate()
        }
    }
    
    func getListUser(category: String){
        ref.child("PlayHistory").observeSingleEvent(of: .value, with: {
            snapshot in
            for category in snapshot.children {
                let q = UserRank(key: (category as AnyObject).key)
                self.getDataRank(user: q.key, category: self.category)
            }
        })
    }
    
    func getDataRank(user: String, category: String){
        self.ref.child("PlayHistory").child(user).child(category).queryOrdered(byChild: "score").queryLimited(toLast: 1).observe(.value) { snapshot in
            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String: Any] else {
                    return
                }
                
                let score = dict["score"] as! Int
                let time = dict["time"] as! Int
                let username = dict["username"] as! String
                
                let q = UserRank(key: user, score: score, time: time, username: username)
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
        } else {
            imageName = "unranked"
        }
        
        cell.configure(imageName: imageName, score: listRankingForView[indexPath.row].score, time: listRankingForView[indexPath.row].time, username: listRankingForView[indexPath.row].username)
        
        return cell
    }
}
