//
//  AnswerViewCell.swift
//  Team1_QuizApp
//
//  Created by Vuong Vu Bac Son on 9/3/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class AnswerViewCell: UITableViewCell {
    
    // AUTHOR: Vuong Vu Bac Son
    @IBOutlet weak var imageCheckBox: UIImageView!
    @IBOutlet weak var txtChoice: UITextView!
    
    static let identifier = "answerCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "AnswerViewCell", bundle: nil)
    }

    public func configure(imageName: String, answer: String) {
        imageCheckBox.image = UIImage(named: imageName)
        txtChoice.text = answer
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
