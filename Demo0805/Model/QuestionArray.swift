//
//  QuestionArray.swift
//  Demo0805
//
//  Created by 林思甯 on 2021/8/6.
//

import Foundation

struct QuestionArray: Codable {
    let response_code: Int
    let results: [StoreItem]
}

struct StoreItem: Codable {
    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
}

struct passCategory {
    let passCategory: String
}

struct passDifficulty {
    let passDifficulty: String
}

struct passScore {
    let score: Int
}

class ShowTime {
    //start time
    private var startTime: Date?
    //elapsed time
    var elapsedTime: TimeInterval {
        if let startTime = self.startTime {
            return -startTime.timeIntervalSinceNow
        } else {
            return 0
        }
    }
    // elapsed time to Sting
    var elapsedTimeAsString: String {
        return String(format: "%02d:%02d.%d", Int(elapsedTime / 60),Int(elapsedTime.truncatingRemainder(dividingBy: 60)), Int((elapsedTime * 10).truncatingRemainder(dividingBy: 10)))
    }
    // is start?
    var isRunning: Bool {
        return startTime != nil
    }
    
    func start() {
        startTime = Date()
    }
    
    func stop() {
        startTime = nil
    }
}

struct passTimer {
    var timer: String
}

struct passPlayerName {
    var name: String
}
