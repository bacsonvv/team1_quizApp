//
//  CategoryTableViewCell.swift
//  Team1_QuizApp
//
//  Created by Nguyen Thi Huong on 9/3/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblNumberOfQuestion: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 20
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    } 
//    func setupCategory(colection: Collection) {
//        self.lblCategory.text = colection.category
//        self.lblTime.text = "60"
//        self.lblNumberOfQuestion.text = "20"
//    }
}
