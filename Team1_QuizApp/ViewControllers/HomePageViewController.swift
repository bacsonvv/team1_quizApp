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
    var user = ""
    var id = ""

    var ref: DatabaseReference!


    var userId = ""
    var username = ""
    var numberOfQuiz = 15
    var timeLimit = 150
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tabBarItem.tag = TabbarItemTag.firstViewController.rawValue
        
        id = UserDefaults.standard.string(forKey: "idUser") ?? "Undefined"
        user = UserDefaults.standard.string(forKey: "nameUserSession") ?? "Undefined"
        
        lblName.text = user
        ref = Database.database().reference()
    }
    
    func storeUserSetting() {
        let userSettings = [
            "username": self.username,
            "numberOfQuiz": self.numberOfQuiz,
            "timeLimit": self.timeLimit] as [String: Any]
        
        self.ref.child("Users").child(userId).setValue(userSettings, withCompletionBlock: { error, ref in
            if error == nil {}
            else {}
        })
    }
}
