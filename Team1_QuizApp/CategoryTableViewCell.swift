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
    @IBOutlet weak var btnAction: UIButton!
    
    
    // khai báo một biến start kiểu closure
    var start: (() -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func startDidpress(_ sender: Any) {
        
        // gọi closure
        // ?: có đối tượng nào lắng nghe (hứng start) thì mới k nil
        start?()
    }
    
    func setupCategory(colection: Collection) {
        self.lblCategory.text = colection.category
        self.lblTime.text = "60"
        self.lblNumberOfQuestion.text = "20"
    }
}
