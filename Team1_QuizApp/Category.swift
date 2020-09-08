//
//  ImageCell.swift
//  Team1_QuizApp
//
//  Created by Nguyen Thi Huong on 9/8/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

struct Category: Codable {
    let data: [CategoryAttribute]
}

struct CategoryAttribute: Codable {
    let category: String
    let image: String
}
