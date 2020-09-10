//
//  SettingViewController.swift
//  Team1_QuizApp
//
//  Created by Nguyen Thi Huong on 9/9/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SettingViewController: UIViewController {

    var ref: DatabaseReference!
    
    @IBOutlet weak var inputUsername: UITextField!
    @IBOutlet weak var inputTime: UITextField!
    @IBOutlet weak var inputQuestion: UITextField!
    @IBOutlet weak var lblUsername: UILabel!
    
    var userId = ""
    var username = ""
    var timeLimit = 0
    var numberOfQuestions = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        userId = UserDefaults.standard.string(forKey: "idUser") ?? "Undefined"
        username = UserDefaults.standard.string(forKey: "username") ?? "Undefined"
        timeLimit = UserDefaults.standard.integer(forKey: "timeLimit")
        numberOfQuestions = UserDefaults.standard.integer(forKey: "numberOfQuestions")
        
        inputUsername.text = self.username
        inputTime.text = "\(self.timeLimit)"
        inputQuestion.text = "\(self.numberOfQuestions)"
        lblUsername.text = username

        tabBarItem.tag = TabbarItemTag.fifthViewConroller.rawValue
    }
    
    @IBAction func btnSubmitClicked(_ sender: Any) {
        self.username = "\(String(describing: inputUsername.text))"
        self.timeLimit = Int(inputTime.text ?? "") ?? 0
        self.numberOfQuestions = Int(inputQuestion.text ?? "") ?? 0
        
        if inputUsername.text == "" || inputTime.text == "" || inputQuestion.text == "" {
            let alert = UIAlertController(title: "INVALID INPUT", message: "Required fields can not be blank! Please try again.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if numberOfQuestions > 30 {
            let alert = UIAlertController(title: "INVALID INPUT", message: "Number of questions can not be greater than 30! Please try again.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if timeLimit <= 0 || numberOfQuestions <= 0 {
            let alert = UIAlertController(title: "INVALID INPUT", message: "Time Limit and Questions fields must be greater than zero! Please try again.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "SUCCESS", message: "Your settings have been saved!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            DispatchQueue.main.async {
                self.storeUserSettings(username: self.inputUsername.text!, timeLimit: self.timeLimit, numberOfQuestions: self.numberOfQuestions)
            }
        }
    }
    
    func storeUserSettings(username: String, timeLimit: Int, numberOfQuestions: Int) {
        let userSettings = [
            "username": username,
            "timeLimit": timeLimit,
            "numberOfQuestions": numberOfQuestions] as [String : Any]
        
        
        self.ref.child("Users").child(userId).setValue(userSettings, withCompletionBlock: { error, ref in
            if error == nil {
            } else {
            }
        })
        
    }
    
    @IBAction func btnHistoryClicked(_ sender: Any) {
    }
    
    @IBAction func btnLogoutClicked(_ sender: Any) {
    }
}
