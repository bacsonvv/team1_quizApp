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
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageCategory: UIImageView!
    @IBOutlet weak var btnDetail: UIButton!
    @IBOutlet weak var btnTest: UIButton!
    @IBOutlet weak var btnHistory: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        imageCategory.layer.borderWidth = 1
//        imageCategory.layer.masksToBounds = false
//        imageCategory.layer.borderColor = UIColor.gray.cgColor
//        imageCategory.layer.cornerRadius = 20
//        imageCategory.clipsToBounds = true

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setupLayout() {
          self.layer.borderWidth = 1
              self.layer.masksToBounds = false
              self.layer.borderColor = UIColor.gray.cgColor
              self.layer.cornerRadius = 20
              self.clipsToBounds = true
    }
    
//    func setImage(data: CategoryAttribute) {
//        lblCategory.text = data.category
//        imageCategory.image = data.image
//        
//        
//    }
}
