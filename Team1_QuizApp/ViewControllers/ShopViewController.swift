//
//  ShopViewController.swift
//  Team1_QuizApp
//
//  Created by Nguyen Thi Huong on 9/9/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }
    
    
    func setupNavigation() {
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.setHidesBackButton(true, animated: false)    }
    
}
