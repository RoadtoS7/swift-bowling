//
//  Score.swift
//  Bowling
//
//  Created by nylah.j on 2022/05/30.
//

import Foundation

struct Score {
    private var turnsLeft: Int
    private var score: Int
    
    var current: Int {
        set {
            score = newValue
        }
        
        get {
            guard canCalulateScore else {
                fatalError()
            }
            return score
        }
    }
    
    init(score: Int, turnsLeft: Int) {
        self.score = score
        self.turnsLeft = turnsLeft
    }
    
    var canCalulateScore: Bool {
        turnsLeft == 0
    }
    
    mutating func bowl(pinsFallen: Int) -> Score {
        current += pinsFallen
        return Score(score: current, turnsLeft: turnsLeft - 1)
    }
    
    func cacluateAdditionalScore(before: Score) -> Int {
        // TODO: beforeScore에 현재 Frame의 쓰러진 Pin을 추가해 점수를 구하는 로직 구현
        fatalError("TODO: beforeScore에 현재 Frame의 쓰러진 Pin을 추가해 점수를 구하는 로직 구현")
        return 0
    }
}
