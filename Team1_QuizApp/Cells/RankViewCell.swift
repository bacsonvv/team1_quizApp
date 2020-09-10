//
//  RankViewCell.swift
//  Team1_QuizApp
//
//  Created by Vuong Vu Bac Son on 9/9/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class RankViewCell: UITableViewCell {
    
    @IBOutlet weak var imageRanking: UIImageView!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var viewContent: UIView!
    
    static let identifier = "rankCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "RankViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        customizeLayout()
    }
    
    func configure(imageName: String, score: Int, time: Int, username: String) {
        imageRanking.image = UIImage(named: imageName)
        lblScore.text = "Score: \(score)"
        lblTime.text = "Time: \(time)"
        lblUsername.text = "\(username)"
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
