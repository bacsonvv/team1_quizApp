//
//  QuestionViewCell.swift
//  Team1_QuizApp
//
//  Created by Vuong Vu Bac Son on 9/7/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class QuestionViewCell: UITableViewCell {
    
    static let identifier = "questionCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "QuestionViewCell", bundle: nil)
    }

    @IBOutlet weak var txtQuestion: UITextView!
    
    func configure(question: String) {
        txtQuestion.text = question
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
