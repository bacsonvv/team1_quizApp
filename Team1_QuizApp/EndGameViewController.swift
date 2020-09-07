//
//  EndGameViewController.swift
//  Team1_QuizApp
//
//  Created by Vuong Vu Bac Son on 9/4/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class EndGameViewController: UIViewController {
    
    var category = "Default"
    var time = 0
    var score = 0

    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblCategory.text = "Category: \(self.category)"
        lblCategory.textColor = .white
        lblTime.text = "Time: \(String(self.time)) seconds"
        lblTime.textColor = .white
        lblScore.text = "Score \(String(self.score))/15"
        lblScore.textColor = .white
        
        self.view.backgroundColor = .purple
    }
    
}
