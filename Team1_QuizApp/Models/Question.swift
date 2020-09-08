//
//  Question.swift
//  Team1_QuizApp
//
//  Created by Vuong Vu Bac Son on 9/4/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

// AUTHOR: Vuong Vu Bac Son
struct Question: Codable {
    let question: String
    let choice1: String
    let choice2: String
    let choice3: String
    let choice4: String
    let answer: String
    let id: Int
    
    init(question: String, choice1: String, choice2: String, choice3: String, choice4: String, answer: String, id: Int) {
        self.question = question
        self.choice1 = choice1
        self.choice2 = choice2
        self.choice3 = choice3
        self.choice4 = choice4
        self.answer = answer
        self.id = id
    }
}
