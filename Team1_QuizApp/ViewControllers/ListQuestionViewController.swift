//
//  ListQuestionViewController.swift
//  Team1_QuizApp
//
//  Created by Vuong Vu Bac Son on 9/7/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ListQuestionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var lblLoading: UILabel!
    
    var listQuestion = [Question]()
    var questionForView = Array<Question>(repeating: Question(question: "Default", choice1: "Default", choice2: "Default", choice3: "Default", choice4: "Default", answer: "Default", id: 0), count: 30)
    var spreadSheetId = "1urSOD9SR3lSD7WE1SF0CqKRa7c1INR9I-iMqQgwsKvM"
    var ref: DatabaseReference!
    var category = ""
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(QuestionViewCell.nib(), forCellReuseIdentifier: QuestionViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        loadingView.isHidden = false
        lblLoading.isHidden = false
        loadingView.startAnimating()
        setStateForView(state: true)
        
        self.ref = Database.database().reference()
        
        DispatchQueue.main.async {
            self.fetchData(self.category)
        }
        
        self.title = category
        
        checkWhenDataIsReady()
        
        tableView.reloadData()
    }
    
    func fetchData(_ category: String){
        self.ref.child(self.spreadSheetId).child(category).observeSingleEvent(of: .value) { snapshot in
            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String:Any] else {
                    return
                }
                
                let question = dict["Question"] as! String
                let choice1 = dict["Choice1"] as! String
                let choice2 = dict["Choice2"] as! String
                let choice3 = dict["Choice3"] as! String
                let choice4 = dict["Choice4"] as! String
                let answer = dict["Answer"] as! String
                let id = dict["Id"] as! Int
                
                let q = Question(question: question, choice1: choice1, choice2: choice2, choice3: choice3, choice4: choice4, answer: answer, id: id)
                self.listQuestion.append(q)
            }
        }
    }
    
    func setStateForView(state: Bool) {
        tableView.isHidden = state
    }

    func checkWhenDataIsReady() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ListQuestionViewController.finishLoading)), userInfo: nil, repeats: true)
    }
    
    @objc func finishLoading() {
        if listQuestion.count != 0 {
            loadingView.isHidden = true
            lblLoading.isHidden = true
            loadingView.stopAnimating()
            
            questionForView.removeAll()
            questionForView = listQuestion
            
            setStateForView(state: false)
            
            tableView.reloadData()
            
            timer.invalidate()
        }
    }
    
    @IBAction func backToHome(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "tabBarVC")
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ListQuestionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionForView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuestionViewCell.identifier, for: indexPath) as! QuestionViewCell
        
        cell.configure(question: questionForView[indexPath.row].question)
        
        return cell
    }
}
