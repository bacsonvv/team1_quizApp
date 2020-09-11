//
//  HomePageViewController.swift
//  Team1_QuizApp
//
//  Created by Nguyen Thi Huong on 9/9/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HomePageViewController: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    
    var ref: DatabaseReference!

    var userId = ""
    var username: String?
    var numberOfQuestions: Int?
    var timeLimit: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarItem.tag = TabbarItemTag.firstViewController.rawValue
        
        userId = UserDefaults.standard.string(forKey: "idUser") ?? "Undefined"
        username = UserDefaults.standard.string(forKey: "username") ?? "Undefined"
        
        lblName.text = username
        ref = Database.database().reference()
        
        DispatchQueue.main.async {
            self.checkUserExist(userId: self.userId)
        }
    }
    
    func checkUserExist(userId: String) {
        ref.child("Users").observeSingleEvent(of: .value, with: {
            (snapshot) in
            if snapshot.hasChild(userId) {
                self.ref.child("Users").child(userId).observeSingleEvent(of: .value, with: {
                    (snapshot) in
                    let dict = snapshot.value as? NSDictionary
                    
                    self.numberOfQuestions = (dict!["numberOfQuestions"] as! Int)
                    self.timeLimit = (dict!["timeLimit"] as! Int)
                    self.username = (dict!["username"] as! String)
                    
                    UserDefaults.standard.set(self.numberOfQuestions, forKey: "numberOfQuestions")
                    UserDefaults.standard.set(self.timeLimit, forKey: "timeLimit")
                    UserDefaults.standard.set(self.username, forKey: "username")
                })
            } else {
                let userSettings = [
                "username": self.username ?? "",
                "numberOfQuestions": 15,
                "timeLimit": 150] as [String: Any]
                
                self.ref.child("Users").child(userId).setValue(userSettings, withCompletionBlock: {
                error, ref in
                if error == nil {}
                else {}
                })
                
                UserDefaults.standard.set(15, forKey: "numberOfQuestions")
                UserDefaults.standard.set(150, forKey: "timeLimit")
                UserDefaults.standard.set(self.username, forKey: "username")
            }
        })
    }
}

