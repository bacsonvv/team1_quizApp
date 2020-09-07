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
    @IBOutlet weak var imageUser: UIImageView!
    

    @IBOutlet weak var lblTitle: UILabel!

    @IBOutlet weak var btnDetail: UIButton!
    @IBOutlet weak var btnHistory: UIButton!
    @IBOutlet weak var btnStart: UIButton!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var timer = Timer()

    
    let cellID = "CategoryTableViewCell"
    
    var listCollection = [""]
    
    //var collection = [Collection]()
    
    var ref = Database.database().reference()
    
    var spreadSheetId = "1urSOD9SR3lSD7WE1SF0CqKRa7c1INR9I-iMqQgwsKvM"
    
    var user = ""
    
    var id = ""
    
    //var tag = 0
    
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
        
        id = UserDefaults.standard.string(forKey: "idUser") ?? "kh"
        print(id)
        setupNavigation()
        
        
        lblEmail.text = "Name Player : \(UserDefaults.standard.string(forKey: "nameUserSession") ?? "Underfined")"
        //        if tag == 0 {
        //            lblEmail.text = "Name: \(user)"
        //        } else {
        //            lblEmail.text = "Email: \(user)"
        //        }
        imageUser.tintColor = .blue
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        
        setStateForView(state: true)
        
        loading.isHidden = false
        loading.startAnimating()
        
        DispatchQueue.main.async {
            self.GetListCategory()
        }
        
        checkWhenDataIsReady()
        
        categoryTableView.reloadData()
        
        initComponent()
        
        lblTitle.font = UIFont.italicSystemFont(ofSize: 17)
        
    }
    
    func checkWhenDataIsReady() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(HomeViewController.setupData)), userInfo: nil, repeats: true)
    }
    @objc func setupData() {
        if listCollection.count == 3 {
            loading.isHidden = true
            loading.stopAnimating()
            
            setStateForView(state: false)

            timer.invalidate()
        }
    }
    
    func setStateForView(state: Bool) {
        lblEmail.isHidden = state
        imageUser.isHidden = state
        btnDetail.isHidden = state
        btnHistory.isHidden = state
        btnStart.isHidden = state
    }
    
    fileprivate func initComponent() {
        categoryTableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: cellID)
    }
    
    func setupNavigation() {
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.71, green: 0.61, blue: 0.71, alpha: 1)
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.title = "Subject Matter"
        navigationItem.titleView = titleNavigationLabel
        
        let btnRightBar = UIBarButtonItem(image: UIImage(systemName: "arrow.left.square"), style: .plain, target: self, action: #selector(signOut))
        self.navigationItem.rightBarButtonItem  = btnRightBar
    }
    
    @objc func signOut() {
        self.navigationController?.popViewController(animated: true)
        UserDefaults.standard.removeObject(forKey: "option")
        UserDefaults.standard.removeObject(forKey: "nameUserSession")
        UserDefaults.standard.removeObject(forKey: "idGG")
        UserDefaults.standard.removeObject(forKey: "idFB")
    }
    
    @IBAction func showListQuestion(_ sender: Any) {
        print("aloooo")
        if chooseCategory == -1 {
            showDialog()
        } else {
            showListQ()
        }
    }
    
    func showListQ() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "listQVC") as! ListQuestionViewController
        vc.category = listCollection[chooseCategory]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func startGame(_ sender: Any) {
        print("ollllaaa")
        if chooseCategory == -1 {
            showDialog()
        } else {
            startGame()
        }
    }
    
    func startGame() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "gameVC") as! GameViewController
        vc.category = listCollection[chooseCategory]
//        vc.userId = self.user
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showDialog() {
        let alert = UIAlertController(title: "No category selected ", message: "Please pick any item to continue", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBAction func showHistory(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "historyView") as! HistoryViewController
        vc.userId = self.user
        vc.categroy = listCollection[chooseCategory]
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
        chooseCategory = indexPath.row
        
    }
}
