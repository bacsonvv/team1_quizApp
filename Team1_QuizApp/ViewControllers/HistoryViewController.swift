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
    
    @IBOutlet weak var civicEducationView: UIView!
    @IBOutlet weak var geographyView: UIView!
    @IBOutlet weak var historyView: UIView!
    
    @IBOutlet weak var lblCivicEducation: UILabel!
    @IBOutlet weak var lblGeography: UILabel!
    @IBOutlet weak var lblHistory: UILabel!
    
    var refreshControl = UIRefreshControl()
    
    var userId = ""
    var category = "Civic Education"
    var ref: DatabaseReference!
    var listUser: [UserHistory] = []
    var listUserForView: [UserHistory] = [UserHistory(score: 0, time: 0, playDate: "")]
    var timer = Timer()
    var loadingTime = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Reload data")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        tabBarItem.tag = TabbarItemTag.fourthViewConroller.rawValue
        
        let civicEducationGesture = UITapGestureRecognizer(target: self, action:  #selector(self.civicEducationClicked))
        self.civicEducationView.addGestureRecognizer(civicEducationGesture)
        
        let geographyGesture = UITapGestureRecognizer(target: self, action:  #selector(self.geographyClicked))
        self.geographyView.addGestureRecognizer(geographyGesture)
        
        let historyGesture = UITapGestureRecognizer(target: self, action:  #selector(self.historyClicked))
        self.historyView.addGestureRecognizer(historyGesture)

        tableView.register(HistoryViewCell.nib(), forCellReuseIdentifier: HistoryViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        setupViewBorder(view: civicEducationView)
        setupViewBorder(view: geographyView)
        setupViewBorder(view: historyView)
        
        self.title = "Play Result"
        
        civicEducationView.backgroundColor = .blue
        lblCivicEducation.textColor = .white
        
        initTableView()
        
        tableView.reloadData()
    }
    
    func initTableView() {
        loading.isHidden = false
        loading.startAnimating()
        lblLoading.isHidden = false
        
        setStateForView(state: true)
        
        DispatchQueue.main.async {
            self.getUserHistory(category: self.category)
        }
        
        checkWhenDataIsReady()
        
    }
    
    @objc func refresh(_ sender: AnyObject) {
        DispatchQueue.main.async {
            self.getUserHistory(category: self.category)
        }
        
        refreshControl.endRefreshing()
    }
    
    func setupViewBorder(view: UIView) {
        view.layer.cornerRadius = 15
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.clipsToBounds = true
    }
    
    @objc func civicEducationClicked(sender : UITapGestureRecognizer) {
        reInitLoading()
        
        civicEducationView.backgroundColor = .blue
        lblCivicEducation.textColor = .white
        
        geographyView.backgroundColor = .white
        lblGeography.textColor = .black
        
        historyView.backgroundColor = .white
        lblHistory.textColor = .black
        
        self.category = "Civic Education"
        
        initTableView()
    }
    
    @objc func geographyClicked(sender : UITapGestureRecognizer) {
        reInitLoading()
        
        geographyView.backgroundColor = .purple
        lblGeography.textColor = .white
        
        historyView.backgroundColor = .white
        lblHistory.textColor = .black
        
        civicEducationView.backgroundColor = .white
        lblCivicEducation.textColor = .black
        
        self.category = "Geography"
        
        initTableView()
    }
    
    @objc func historyClicked(sender : UITapGestureRecognizer) {
        reInitLoading()
        
        historyView.backgroundColor = .red
        lblHistory.textColor = .white
        
        civicEducationView.backgroundColor = .white
        lblCivicEducation.textColor = .black
        
        geographyView.backgroundColor = .white
        lblGeography.textColor = .black
        
        self.category = "History"
        
        initTableView()
    }
    
    func reInitLoading() {
        lblLoading.text = "Wait for a moment..."
        loadingTime = 0
    }
    
    func checkWhenDataIsReady() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(HistoryViewController.finishLoading)), userInfo: nil, repeats: true)
    }
    
    @objc func finishLoading() {
        loadingTime += 1
        
        if loadingTime == 3 {
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
    
    func getUserHistory(category: String) {
        listUser.removeAll()
        self.ref.child("PlayHistory").child(userId).child(category).observeSingleEvent(of: .value) { snapshot in
            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String:Any] else {
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
        return listUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryViewCell.identifier, for: indexPath) as! HistoryViewCell
        cell.configure(score: self.listUser[indexPath.row].score, time: self.listUser[indexPath.row].time, playDate: self.listUser[indexPath.row].playDate)
        
        return cell
    }

}
