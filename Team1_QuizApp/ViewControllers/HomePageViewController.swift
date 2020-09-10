//
//  HomePageViewController.swift
//  Team1_QuizApp
//
//  Created by Nguyen Thi Huong on 9/9/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    var user = ""
    var id = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarItem.tag = TabbarItemTag.firstViewController.rawValue
        
        id = UserDefaults.standard.string(forKey: "idUser") ?? "Undefined"
        user = UserDefaults.standard.string(forKey: "nameUserSession") ?? "Undefined"
        
        lblName.text = user
        
    }
}
