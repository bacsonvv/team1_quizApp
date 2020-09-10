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
    
    var userId = "123123"
    
    var username = "Vuong Vu Bac Son"
    var timeLimit = 150
    var questions = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        ref = Database.database().reference()
        
        inputUsername.text = self.username
        inputTime.text = "\(self.timeLimit)"
        inputQuestion.text = "\(self.questions)"


        tabBarItem.tag = TabbarItemTag.fifthViewConroller.rawValue
    }
    
    @IBAction func btnSubmitClicked(_ sender: Any) {
        self.username = "\(String(describing: inputUsername.text))"
        self.timeLimit = Int(inputTime.text ?? "") ?? 0
        self.questions = Int(inputQuestion.text ?? "") ?? 0
//        let intTime = Int(time ?? "") ?? 0
//        let intQuestions = Int(questions ?? "") ?? 0
//        let numbersSet = CharacterSet(charactersIn: "0123456789")
//        let timeCharacterSet = CharacterSet(charactersIn: time!)
//        let questionsCharacterSet = CharacterSet(charactersIn: questions!)
        
        if inputUsername.text == "" || inputTime.text == "" || inputQuestion.text == "" {
            let alert = UIAlertController(title: "INVALID INPUT", message: "Required fields can not be blank! Please try again.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if questions > 30 {
            let alert = UIAlertController(title: "INVALID INPUT", message: "Number of questions can not be greater than 30! Please try again.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if timeLimit <= 0 || questions <= 0 {
            let alert = UIAlertController(title: "INVALID INPUT", message: "Time Limit and Questions fields must be greater than zero! Please try again.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "SUCCESS", message: "Your settings have been saved!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            DispatchQueue.main.async {
                self.storeUserSettings(username: self.inputUsername.text!, timeLimit: self.timeLimit, numberOfQuestions: self.questions)
            }
        }
//        if !timeCharacterSet.isSuperset(of: numbersSet) || !questionsCharacterSet.isSuperset(of: numbersSet) {
//            let alert = UIAlertController(title: "INVALID INPUT", message: "Time Limit or Questions fields contain number only! Please try again.", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
    }
    
    func storeUserSettings(username: String, timeLimit: Int, numberOfQuestions: Int) {
        let userSettings = [
            "username": username,
            "time": timeLimit,
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
