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
    
    var category = "Default"
    var time = 0
    var score = 0
    var userId = "123"

    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        lblCategory.text = "Category: \(self.category)"
        lblCategory.textColor = .white
        lblTime.text = "Time: \(String(self.time)) seconds"
        lblTime.textColor = .white
        lblScore.text = "Score \(String(self.score))/15"
        lblScore.textColor = .white
        
        self.view.backgroundColor = .purple
        
        storeUserResult()
    }
    
    @IBAction func playAgain(_ sender: Any) {
        let homeViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "homeVC") as! HomeViewController
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    func storeUserResult() {
        let userHistory = [
            "score": self.score,
            "time": self.time] as [String : Any]
        
        
        self.ref.child("PlayHistory").child(userId).child(category).childByAutoId().setValue(userHistory, withCompletionBlock: { error, ref in
            if error == nil {
            } else {
            }
        })
        
    }
    
}
