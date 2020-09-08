//
//  Collection.swift
//  Team1_QuizApp
//
//  Created by Vuong Vu Bac Son on 9/8/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

// Huong
// collection là bộ đề
struct Collection: Codable{
    // chủ đề
    let category: String
    // Thời gian mỗi bộ đề
    let time: String
    // Số lượng câu hỏi trong bộ đề
    let numberOfQuestion: String
    // mảng câu hỏi có trong bộ đề
    let questions: [Question]
}
