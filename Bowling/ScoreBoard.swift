//
//  ScoreBoard.swift
//  Bowling
//
//  Created by nylah.j on 2022/05/28.
//

import Foundation

struct ScoreBoard {
    let frames: BowlingFrames
    
    var maxFrameIndex: Int { frames.count - 1 }
    
    func frame(of index: Int) -> Frame { frames[index] }
}

struct TestScoreBoard {
    let frame: TestFrame
}

