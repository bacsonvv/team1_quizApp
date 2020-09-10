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

    @IBOutlet weak var txtQuestion: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    func configure(question: String) {
        txtQuestion.text = question
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.darkGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
