//
//  UserRank.swift
//  Team1_QuizApp
//
//  Created by Vuong Vu Bac Son on 9/9/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation
class UserRank {
    var key = ""
    var score = 0
    var time = 0
    var username = ""
    
    init(key: String, score: Int, time: Int, username: String) {
        self.key = key
        self.score = score
        self.time = time
        self.username = username
    }
    init(key: String) {
        self.key = key
    }
}
