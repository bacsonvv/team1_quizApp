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
    
    var chooseCategory = -1
    
    let titleNavigationLabel: UILabel = {
        let label = UILabel()
        label.text = "Master Subject"
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.title = "Subject Matter"
        let btnRightBar = UIBarButtonItem(image: UIImage(systemName: "imagename"), style: .plain, target: self, action: #selector(signOut)) // action:#selector(Class.MethodName) for swift 3
        self.navigationItem.rightBarButtonItem  = btnRightBar
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: UIImage(named: "System"), style: .done, target: self, action: #selector(signOut))
        
        if tag == 0 {
            lblEmail.text = "Name: \(user)"
        } else {
            lblEmail.text = "Email: \(user)"
        }
        
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        
        GetListCategory()
        initComponent()
        setupNavigation()
    }
    
    fileprivate func initComponent() {
        categoryTableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: cellID)
    }
    
    func setupNavigation() {
        navigationController?.navigationBar.barTintColor = UIColor.blue
        navigationItem.titleView = titleNavigationLabel
        
        //      navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    @objc func signOut() {
        
    }
    
    @IBAction func showListQuestion(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "listQVC") as! ListQuestionViewController
        vc.category = listCollection[chooseCategory]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func startGame(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "gameVC") as! GameViewController
        vc.category = listCollection[chooseCategory]
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
      
        chooseCategory = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          if let cell = tableView.cellForRow(at: indexPath) {
              cell.contentView.backgroundColor = UIColor.darkGray
          }
      }
}
