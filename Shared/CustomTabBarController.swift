//
//  CustomTabBarController.swift
//  Team1_QuizApp
//
//  Created by Nguyen Thi Huong on 9/10/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

enum TabbarItemTag: Int {
    case firstViewController = 101
    case secondViewConroller = 102
    case thirdViewController = 103
    case fourthViewConroller = 104
    case fifthViewConroller = 105
}

class CustomTabBarController: UITabBarController {
    var firstTabbarItemImageView: UIImageView!
    var secondTabbarItemImageView: UIImageView!
    var thirdTabbarItemImageView: UIImageView!
    var fourthTabbarItemImageView: UIImageView!
    var fifthTabbarItemImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstItemView = tabBar.subviews.first!
        firstTabbarItemImageView = firstItemView.subviews.first as? UIImageView
        firstTabbarItemImageView.contentMode = .center
        
        let secondItemView = self.tabBar.subviews[1]
        self.secondTabbarItemImageView = secondItemView.subviews.first as? UIImageView
        self.secondTabbarItemImageView.contentMode = .center
        
        let thirdItemView = self.tabBar.subviews[2]
        self.thirdTabbarItemImageView = thirdItemView.subviews.first as? UIImageView
        self.thirdTabbarItemImageView.contentMode = .center
        
        let fourthItemView = self.tabBar.subviews[3]
        self.fourthTabbarItemImageView = fourthItemView.subviews.first as? UIImageView
        self.fourthTabbarItemImageView.contentMode = .center
        
        let fifthItemView = self.tabBar.subviews[4]
        self.fifthTabbarItemImageView = fifthItemView.subviews.first as? UIImageView
        self.fifthTabbarItemImageView.contentMode = .center
    }
    
    private func animate(_ imageView: UIImageView) {
        UIView.animate(withDuration: 0.1, animations: {
            imageView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }) { _ in
            UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 3.0, options: .curveEaseInOut, animations: {
                imageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let tabbarItemTag = TabbarItemTag(rawValue: item.tag) else {
            return
        }
        
        switch tabbarItemTag {
        case .firstViewController:
            animate(firstTabbarItemImageView)
        case .secondViewConroller:
            animate(secondTabbarItemImageView)
        case .thirdViewController:
            animate(thirdTabbarItemImageView)
        case .fourthViewConroller:
            animate(fourthTabbarItemImageView)
        case .fifthViewConroller:
            animate(fifthTabbarItemImageView)
        }
    }
}
