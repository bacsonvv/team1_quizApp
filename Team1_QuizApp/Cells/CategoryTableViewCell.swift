//
//  CategoryTableViewCell.swift
//  Team1_QuizApp
//
//  Created by Nguyen Thi Huong on 9/3/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

protocol CategoryDelegate: class {
    func didTapButton(with: String , nameCat : String)
}

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var imageCategory: UIImageView!
    @IBOutlet weak var blurCategory: UIVisualEffectView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblNumberOfQuestion: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var btnDetail: UIButton!
    @IBOutlet weak var btnTest: UIButton!
    
    var nameCategory = "History"
    
    weak var delegate: CategoryDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
          
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = false
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 5)
        containerView.layer.shadowColor = UIColor.black.cgColor

    
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func seeListQuestion(_ sender: Any) {
        
        delegate?.didTapButton(with: "see", nameCat: self.nameCategory)
    }
    
    @IBAction func qickTest(_ sender: Any) {
        
        delegate?.didTapButton(with: "test", nameCat: self.nameCategory)
    }
    
}

