//
//  TabBarController.swift
//  Team1_QuizApp
//
//  Created by Nguyen Thi Huong on 9/9/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var timer: Timer!
    var location: NSLayoutConstraint?
   
    // Thêm animation vào tabbar sau sự kiện chọn tabBarItem
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
      let index = viewControllers!.firstIndex(of: viewController)
      UIView.animate(withDuration: 0.2, animations: {
        self.location!.constant = CGFloat(index!) * UIScreen.main.bounds.maxX / 5
        self.view.layoutIfNeeded()
      })
    }
}
