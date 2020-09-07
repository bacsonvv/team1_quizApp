//
//  HistoryCell.swift
//  Team1_QuizApp
//
//  Created by Van Thanh on 9/7/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lbltest: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

        // Configure the view for the selected state
    }
    public func load(    score: Int  , time: Int ) {
        
        lblScore.text = String(score)
        lblTime.text = String(time)
        
        
    }
    
}
