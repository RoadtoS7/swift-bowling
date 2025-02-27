//
//  BowlingFramesFormat.swift
//  Bowling
//
//  Created by nylah.j on 2022/05/29.
//

import Foundation

struct ScoreBoardFormat {
    private let scoreBoard: ScoreBoard
    private let playerName: PlayerName
    
    private let emptyFrame = "      "
    private let delimiter = "|"
    
    var value: String {
        let header = formatFrameIndex(with: BowlingConstant.maxFrameCount)
        
        let formattedScoreBoard = format(scoreBoard: scoreBoard)
        let formattedName = format(name: playerName)
        
        let result =  ([formattedName] + formattedScoreBoard).reduce(delimiter) { partialResult, element in
            partialResult + element + delimiter
        }
        return header + "\n" + result
    }
    
    private func format(name: PlayerName) -> String {
        let nameFormat = "  %@ "
        return String(format: nameFormat, name.value)
    }
    
    
    private func format(scoreBoard: ScoreBoard) -> [String] {
        return (0..<BowlingConstant.maxFrameCount).map { index -> String in
            if index > scoreBoard.maxFrameIndex {
                return emptyFrame
            }
            return format(frame: scoreBoard.frame(of: index))
        }
    }
    
    private func format(frame: Frame) -> String {
        if let frame = frame as? FinalFrame {
            return format(finalFrame: frame)
        }
        if let frame = frame as? NormalFrame {
            return format(normalFrame: frame)
        }
        return ""
    }
    
    
    private func format(normalFrame: NormalFrame) -> String {
        if normalFrame.counts.count < 2 {
            let formattedScore = format(pinCount: normalFrame.counts[0])
            return frameText(value: formattedScore)
        }
        
        let formattedScores = format(firstScore: normalFrame.counts[0].value, secondScore: normalFrame.counts[1].value)
        return frameText(value: formattedScores)
    }
    
    
    private func format(firstScore: Int, secondScore: Int) -> String {
        let firstScoreText = format(firstScore: firstScore)
        
        if secondScore == BowlingConstant.pinCountOfStrike {
            return firstScoreText + "|" + "X"
        }
        
        if firstScore + secondScore == BowlingConstant.pinCountOfStrike {
            return firstScoreText + "|" + "/"
        }
        
        if secondScore == 0 {
            return firstScoreText + "|" + "-"
        }
        
        return firstScoreText + "|" + "\(secondScore)"
    }
    
    private func format(firstScore: Int) -> String {
        if firstScore == 0 {
            return "-"
        }
        return "\(firstScore)"
    }
    
    private func formatFrameIndex(with frameTotalCount: Int) -> String {
        return (1...frameTotalCount).reduce("| NAME |") { partialResult, index in
            if index == BowlingConstant.maxFrameCount {
                return partialResult + frameText(value: "\(index)") + delimiter
            }
            return partialResult + frameText(value: "0\(index)") + delimiter
            
        }
    }
    
    private func format(finalFrame: FinalFrame) -> String {
        if finalFrame.counts.count == 1 {
            return format(pinCount: finalFrame.counts[0])
        }
        
        let firstCount = finalFrame.counts[0].value
        let secondCount = finalFrame.counts[1].value
        let formattedScores = format(firstScore: firstCount, secondScore: secondCount)
        
        if finalFrame.counts.count == 2 {
            return formattedScores
        }
        
        if firstCount == BowlingConstant.pinCountOfStrike
            || secondCount == BowlingConstant.pinCountOfStrike
            || firstCount + secondCount == BowlingConstant.pinCountOfStrike {
            let result = formattedScores + "|" + format(pinCount: finalFrame.counts[2])
            return frameText(value: result)
        }
        return frameText(value: formattedScores)
    }
    
    func format(pinCount: PinCount) -> String {
        if pinCount.value == 0 {
            return "-"
        }
        if pinCount.value == BowlingConstant.pinCountOfStrike {
            return "X"
        }
        return "\(pinCount.value)"
    }
    
    init(playerName: PlayerName, bowlingFrames: ScoreBoard) {
        self.playerName = playerName
        self.scoreBoard = bowlingFrames
    }
    
    func frameText(value: String) -> String {
        if value.count == 1 {
            return "  \(value)   "
        }
        if value.count == 2 {
            return "  \(value)  "
        }
        if value.count == 3 {
            return "  \(value) "
        }
        if value.count == 5 {
            return "\(value) "
        }
        return ""
    }
}

struct FrameFormat {
    let playerName: PlayerName
    let frame: TestFrame
    
    var value: String {
        let header = formatFrameIndex(with: BowlingConstant.maxFrameCount)
        
        
        
    }
    
    func format(testFrame: TestFrame) -> String {
        var result = ""
        
        var currentFrame = frame
        do {
            switch currentFrame.state {
            case is Ready:
                break
            case is FirstBowl:
                let pinCount = currentFrame.state.score?.score ?? 0
                result += frameText(value: pinCount)
            case let frame as Spare:
                frame.first.value + "/"
            case is Strike:
            case is Miss:
                
            }
            currentFrame = currentFrame.next
            
        }
    }
    
    private func formatFrameIndex(with frameTotalCount: Int) -> String {
        return (1...frameTotalCount).reduce("| NAME |") { partialResult, index in
            if index == BowlingConstant.maxFrameCount {
                return partialResult + frameText(value: "\(index)") + delimiter
            }
            return partialResult + frameText(value: "0\(index)") + delimiter
            
        }
    }
    
    func frameText(value: String) -> String {
        if value.count == 1 {
            return "  \(value)   "
        }
        if value.count == 2 {
            return "  \(value)  "
        }
        if value.count == 3 {
            return "  \(value) "
        }
        if value.count == 5 {
            return "\(value) "
        }
        return ""
    }
    
}
