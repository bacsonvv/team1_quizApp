//
//  GameViewController.swift
//  Team1_QuizApp
//
//  Created by Vuong Vu Bac Son on 9/3/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import FirebaseDatabase

class GameViewController: UIViewController {
    
    // AUTHOR: Vuong Vu Bac Son
    @IBOutlet weak var lblTimeRemain: UILabel!
    @IBOutlet weak var txtQuestion: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinnerWaiting: UIActivityIndicatorView!
    @IBOutlet weak var lblCurrentQuestion: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var btnQuit: UIButton!
    @IBOutlet weak var imageQuestion: UIImageView!
    @IBOutlet weak var imageScore: UIImageView!
    @IBOutlet weak var imageTime: UIImageView!
    @IBOutlet weak var imageQuestions: UIImageView!
    
    var timer = Timer()
    var timer2 = Timer()
    var amountOfTime = 0
    var timeRemaining = 0
    var questionArray = [Question]()
    var spreadSheetId = "1urSOD9SR3lSD7WE1SF0CqKRa7c1INR9I-iMqQgwsKvM"
    var ref: DatabaseReference!
    var numberOfQuestions = 0
    var currentQuestion = 0
    var answerForView = ["Choice1", "Choice2", "Choice3", "Choice4"]
    var userChoice = ""
    var score = 0
    var isClicked = false
    var category = ""
    var userId = ""
    var username = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        tableView.register(AnswerViewCell.nib(), forCellReuseIdentifier: AnswerViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.ref = Database.database().reference()
        
        initGame()
        
        txtQuestion.isEditable = false
        
        DispatchQueue.main.async {
            self.fetchData(category : self.category)
        }
        
        checkWhenDataIsReady()
        
        tableView.reloadData()
        
        runTimer()
        
        btnQuit.layer.cornerRadius = 10
        
        setupNavigation()
    }
    
    override var hidesBottomBarWhenPushed: Bool {
           get {
               return true
           }
           set {
               super.hidesBottomBarWhenPushed = newValue
           }
       }
    
    @objc func endVC(){
        moveToEndGame()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        txtQuestion.centerVertically()
    }
    
    func setupNavigation() {
        
        let btnRightBar = UIBarButtonItem(image: UIImage(systemName: "arrow.left.square"), style: .plain, target: self, action: #selector(endVC))
        self.navigationItem.rightBarButtonItem  = btnRightBar

        self.title = category
    }
    
    func fetchData(category: String){
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
                self.questionArray.append(q)
            }
        }
    }
    
    @IBAction func btnQuitClicked(_ sender: Any) {
        let quitAlert = UIAlertController(title: "WARNING", message: "Are you sure to quit the test? Your result will not be saved!", preferredStyle: UIAlertController.Style.alert)

        quitAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
//            let categoryController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "tabBarVC")
//
//            self.navigationController?.pushViewController(categoryController, animated: true)
            self.navigationController?.popViewController(animated: true)
        }))

        quitAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))

        present(quitAlert, animated: true, completion: nil)
    }
    
    func setStateForView(state: Bool) {
        imageQuestion.isHidden = state
        imageScore.isHidden = state
        imageTime.isHidden = state
        tableView.isHidden = state
        lblTimeRemain.isHidden = state
        txtQuestion.isHidden = state
        btnQuit.isHidden = state
        lblCurrentQuestion.isHidden = state
        lblScore.isHidden = state
        imageQuestions.isHidden = state
    }
    
    func initGame() {
        
        spinnerWaiting.isHidden = false
        spinnerWaiting.startAnimating()
        
        setStateForView(state: true)
        
        timeRemaining = UserDefaults.standard.integer(forKey: "timeLimit")
        numberOfQuestions = UserDefaults.standard.integer(forKey: "numberOfQuestions")
        
        amountOfTime = timeRemaining
    }
    
    func checkWhenDataIsReady() {
        timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(GameViewController.setupData)), userInfo: nil, repeats: true)
    }
    
    @objc func setupData() {
        if questionArray.count != 0 {
            spinnerWaiting.isHidden = true
            spinnerWaiting.stopAnimating()
            
            setStateForView(state: false)
             
            questionArray.shuffle()
            setupQuestion()
            
            timer2.invalidate()
        }
    }
    
    func setupQuestion() {
        userChoice = ""
        answerForView.removeAll()
        txtQuestion.text = self.questionArray[self.currentQuestion].question
        
        answerForView.append(self.questionArray[self.currentQuestion].choice1)
        answerForView.append(self.questionArray[self.currentQuestion].choice2)
        answerForView.append(self.questionArray[self.currentQuestion].choice3)
        answerForView.append(self.questionArray[self.currentQuestion].choice4)
        answerForView.shuffle()
        
        lblCurrentQuestion.text = "\(self.currentQuestion + 1)/\(numberOfQuestions)"
        lblScore.text = "\(self.score)"
        
        isClicked = false
        
        currentQuestion += 1
        tableView.reloadData()
    }
    
    func moveToEndGame() {
        let endGameController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "endGameView") as! EndGameViewController
        endGameController.category = self.category
        endGameController.time = self.amountOfTime - self.timeRemaining
        endGameController.score = self.score
        endGameController.userId = self.userId
        endGameController.username = self.username
        endGameController.playDate = setPlayDate()
        timer.invalidate()
        self.navigationController?.pushViewController(endGameController, animated: true)
    }
    
    func setPlayDate() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "dd-MM-yyyy"
        let formattedDate = format.string(from: date)
        return formattedDate
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(GameViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        timeRemaining -= 1
        lblTimeRemain.text = "\(timeRemaining)"
        lblTimeRemain.textAlignment = .center
        lblTimeRemain.adjustsFontSizeToFitWidth = true
        
        if(timeRemaining == 0) {
            lblTimeRemain.text = "Time"
            lblTimeRemain.textAlignment = .center
            lblTimeRemain.adjustsFontSizeToFitWidth = true
            timer.invalidate()
        }
    }
}

extension GameViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AnswerViewCell.identifier, for: indexPath) as! AnswerViewCell
        
        cell.configure(imageName: "uncheck", answer: answerForView[indexPath.row])
        cell.lblChoice.textColor = .black
        
        return cell
    }    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isClicked {
            let cell = tableView.cellForRow(at: indexPath) as! AnswerViewCell
            self.userChoice = cell.lblChoice.text!
            
            if userChoice == "" {
                let alert = UIAlertController(title: "No answer selected", message: "Please choose an answer", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                if currentQuestion == numberOfQuestions {
                    moveToEndGame()
                } else {
                    if userChoice == String(questionArray[currentQuestion - 1].answer) {
                        cell.imageCheckBox.image = UIImage(named: "check")
                        cell.lblChoice.textColor = .green
                        score += 1
                        lblScore.text = "\(self.score)"
                    } else {
                        cell.imageCheckBox.image = UIImage(named: "wronganswer")
                        cell.lblChoice.textColor = .red
                    }
                    isClicked = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
                        self.setupQuestion()
                    })
                }
            }
        }
    }
}

extension UITextView {
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
}
