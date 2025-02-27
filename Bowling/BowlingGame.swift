//
//  BowlingGame.swift
//  Bowling
//
//  Created by nylah.j on 2022/05/28.
//

import Foundation

class BowlingGame {
    private let playerName: PlayerName
    private let pinCountReader: PinCountReader
    private let stateDelegate: BowlingGameStateDelegate?
    
    private var frames: BowlingFrames
    private var testFrame: TestFrame
    private(set) var currentFrame: TestFrame
    
    init(playerName: PlayerName,
         pinCountReader: PinCountReader,
         stateDelegate: BowlingGameStateDelegate? = nil) {
        self.playerName = playerName
        self.pinCountReader = pinCountReader
        self.stateDelegate = stateDelegate
        
        let frame = NormalFrame()
        self.frames = BowlingFrames(initialFrame: frame)
        self.testFrame = TestFrame(index: 0)
        self.currentFrame = self.testFrame
    }
    
    func start() throws -> ScoreBoard {
        while currentFrame.isNotLastFrame() {
            let pinCount = pinCountReader.readPinCount(ofFrameIndex: currentFrame.index)
            currentFrame = testFrame.bowl(pinsFallen: pinCount)
            
            stateDelegate?.afterReceivePinCount(playerName: playerName, scoreBoard: ScoreBoard(frames: frames))
        }
        
        return ScoreBoard(frames: frames)
    }
    
    func start2() throws -> TestScoreBoard {
        while currentFrame.isNotLastFrame() {
            let pinCount = pinCountReader.readPinCount(ofFrameIndex: currentFrame.index)
            currentFrame = testFrame.bowl(pinsFallen: pinCount)
            
            stateDelegate?.afterReceivePinCount(playerName: playerName, scoreBoard: ScoreBoard(frames: frames))
        }
        
        return TestScoreBoard(frame: testFrame)
    }
}
