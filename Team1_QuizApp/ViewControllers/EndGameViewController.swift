//
//  EndGameViewController.swift
//  Team1_QuizApp
//
//  Created by Vuong Vu Bac Son on 9/4/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import FirebaseDatabase

class EndGameViewController: UIViewController {
    
    var ref: DatabaseReference!
    var category = ""
    var time = 0
    var score = 0
    var playDate = ""
    var userId = ""

    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var btnPlayAgain: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        lblCategory.text = "Category: \(self.category)"
        lblTime.text = "Time: \(String(self.time)) seconds"
        lblScore.text = "Score \(String(self.score))/15"
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        btnPlayAgain.layer.cornerRadius = 10
        
        storeUserResult()
    }
    
    @IBAction func playAgain(_ sender: Any) {
        let homeViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "tabBarVC")
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    func storeUserResult() {
        let userHistory = [
            "score": self.score,
            "time": self.time,
            "playDate": self.playDate] as [String : Any]
        
        
        self.ref.child("PlayHistory").child(userId).child(category).childByAutoId().setValue(userHistory, withCompletionBlock: { error, ref in
            if error == nil {
            } else {
            }
        })
        
    }
    
}
