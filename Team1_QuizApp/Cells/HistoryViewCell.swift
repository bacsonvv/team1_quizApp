//
//  HistoryViewCell.swift
//  Team1_QuizApp
//
//  Created by Vuong Vu Bac Son on 9/7/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class HistoryViewCell: UITableViewCell {

    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    
    static let identifier = "historyCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "HistoryViewCell", bundle: nil)
    }
    
    func configure(score: Int, time: Int, playDate: String) {
        lblScore.text = "Score: \(score)"
        lblTime.text = "Time: \(time) seconds"
        lblDate.text = "Date: \(playDate)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        customizeLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func customizeLayout(){
         containerView.backgroundColor = UIColor.init(displayP3Red: 122, green: 134, blue: 125, alpha: 1)
         containerView.layer.shadowRadius = 10
         containerView.layer.cornerRadius = 10
         containerView.layer.shadowOpacity = 0.5
         containerView.layer.shadowOffset = CGSize(width: 1, height: 1)
     }
}


