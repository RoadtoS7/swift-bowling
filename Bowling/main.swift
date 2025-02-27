//
//  Bowling - main.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import Foundation

struct BowlingPinCountReader: PinCountReader {
    func readPinCount(ofFrameIndex index: Int) -> PinCount {
        let pinCountInput = InputView.readPinCount(of: index)
        return try! PinCountParser.parse(pinCountInput: pinCountInput)
    }
}

struct DefaultBowlingGameStateDelegate: BowlingGameStateDelegate {
    func afterReceivePinCount(playerName: PlayerName, scoreBoard: Frame) {
        
    }
    
    func afterReceivePinCount(playerName: PlayerName, scoreBoard: ScoreBoard) {
        let format = ScoreBoardFormat(playerName: playerName, bowlingFrames: scoreBoard)
        OutputView.print(scoreBoard: format.value)
    }
    
    func afterReceivePinCount(playerName: PlayerName, frame: TestFrame) {
        let format = FrameFormat(playerName: playerName, frame: frame)
        OutputView.print(scoreBoard: format.value)
    }
}


do {
    let nameInput = InputView.readPlayerName()
    let playerName = try PlayerNameParser.parse(nameInput: nameInput)
    
    let bowlingGame = BowlingGame(playerName: playerName,
                                  pinCountReader: BowlingPinCountReader(),
                                  stateDelegate: DefaultBowlingGameStateDelegate())
    let testScoreBoard = try bowlingGame.start2()
    
    
} catch(let error) {
    OutputView.print(error: error)
}

