//
//  HistoryViewCell.swift
//  Team1_QuizApp
//
//  Created by Vuong Vu Bac Son on 9/7/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class HistoryViewCell: UITableViewCell {

    @IBOutlet weak var lblNumberOfQuiz: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    
    static let identifier = "historyCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "HistoryViewCell", bundle: nil)
    }

    
    func configure(numberOfQuiz: Int, score: Int, time: Int) {
        lblNumberOfQuiz.text = "Quiz: \(numberOfQuiz)"
        lblScore.text = "Score: \(score)"
        lblTime.text = "Time: \(time) seconds"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


