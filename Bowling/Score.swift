//
//  Score.swift
//  Bowling
//
//  Created by nylah.j on 2022/05/30.
//

import Foundation

struct Score {
    private(set) var turnsLeft: Int
    private(set) var score: Int
    
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
    
    func bowl(pinsFallen: Int) -> Score {
        return Score(score: current + pinsFallen, turnsLeft: turnsLeft - 1)
    }
}

class TestFrame {
    enum Error: LocalizedError {
        case invaildBowl
        
        var errorDescription: String? {
            switch self {
            case .invaildBowl: return "Bowl은 0개 이상 10개이상의 pin만"
            }
        }
    }
    
    var next: TestFrame?
    var index: Int
    private(set) var state: State
    
    init(index: Int) {
        self.index = index
        self.state = Ready()
    }
    
    func bowl(pinsFallen: PinCount) -> TestFrame {
        state = state.bowl(pinsFallen: pinsFallen)
        if state.isFinished() {
            next = TestFrame(index: index + 1)
            return next!
        }
        return self
    }
    

    var score: Score? { state.score }
    var current: Int? {
        guard let score = score else {
            return nil
        }
        if score.canCalulateScore == true {
            return score.current
        }
        return next?.calculateAdditionalScore(before: score)
    }
    
    func calculateAdditionalScore(before: Score) -> Int? {
        guard let score = score,
            let score = state.calculateAdditionalScore(score: score) else {
            return nil
        }
        
        if score.canCalulateScore {
            return score.current
        }
        return next?.calculateAdditionalScore(before: score)
    }
    
    func isNotLastFrame() -> Bool {
        index != BowlingConstant.maxFrameCount
    }
}

protocol State {
    var score: Score? { get }
    func isFinished() -> Bool
    func bowl(pinsFallen: PinCount) -> State
    func calculateAdditionalScore(score: Score) -> Score?
}

protocol Running: State {}

protocol Finished: State {}

class Ready: Running {
    var score: Score?
    
    
    func calculateAdditionalScore(score: Score) -> Score? {
       return nil
    }
    
    
    
    func bowl(pinsFallen: PinCount) -> State {
        if pinsFallen.isStrike() {
            return Strike()
        }
        return FirstBowl(firstPins: pinsFallen)
    }
    
    func isFinished() -> Bool { false }
    
    func score(before: Score) -> Int? {
        return nil
    }
}

class FirstBowl: Running {
    func calculateAdditionalScore(score: Score) -> Score? {
        let score = score.bowl(pinsFallen: firstPins2.value)
        if score.canCalulateScore {
            return score
        }
        return nil
    }
    
    var score: Score? {
        Score(score: firstPins2.value, turnsLeft: 0)
    }
    
    func bowl(pinsFallen: PinCount) -> State {
        if firstPins2.isSpare(with: pinsFallen) {
            return Spare(first: firstPins2, second: pinsFallen)
        }
        return Miss(first: firstPins2, second: pinsFallen)
    }
    
    let firstPins2: PinCount
    
    init(firstPins: PinCount) {
        self.firstPins2 = firstPins
    }
    
    func isFinished() -> Bool { false }
}

class Strike: Finished {
    func calculateAdditionalScore(score: Score) -> Score? {
        let score = score.bowl(pinsFallen: pins.fallendPins)
        return score
    }
    
    func bowl(pinsFallen: PinCount) -> State {
        return self
    }
    
    let pins = Pins.bowl(fallendPins: 10)
    var score: Score? = Score(score: 10, turnsLeft: 2)
    
    func isFinished() -> Bool { true }
    
    func bowl(pinsFallen: Int) -> State {
        return self
    }
}

class Spare: Finished {
    func calculateAdditionalScore(score: Score) -> Score? {
        let score = score.bowl(pinsFallen: first.value)
        if score.canCalulateScore {
            return score
        }
        return score.bowl(pinsFallen: second.value)
    }
    
    func bowl(pinsFallen: PinCount) -> State {
        return self
    }
    
    func score(before: Score) -> Int {
        return before.current
    }
    
    enum Error: LocalizedError {
        case invalid
        
        var errorDescription: String? {
            switch self {
            case .invalid: return "Spare를 이루는 쓰러진 볼링핀의 합은 10개여야 합니다."
            }
        }
    }
    func isFinished() -> Bool {
        return true
    }
    
    func bowl(pinsFallen: Int) -> State {
        return self
    }
    
    let first: PinCount
    let second: PinCount
    var score: Score? {
        Score(score: first.value + second.value, turnsLeft: 1)
    }
    
    init(first: PinCount, second: PinCount) {
        self.first = first
        self.second = second
    }
    
    func calculateAdditionalScore(score: Score) -> Score {
        var score = score.bowl(pinsFallen: first.value)
        
        if score.canCalulateScore {
            return score
        }
        
        score = score.bowl(pinsFallen: second.value)
        return score
    }
    
}

class Miss: Finished {
    func calculateAdditionalScore(score: Score) -> Score? {
        return score
    }
    
    
    func bowl(pinsFallen: PinCount) -> State {
        return self
    }
        
    func isFinished() -> Bool { true }
    
    func bowl(pinsFallen: Int) -> State {
        return self
    }
    
    private let first: PinCount
    private let second: PinCount
    var score: Score? {
        Score(score: first.value + second.value, turnsLeft: 0)
    }
    
    init(first: PinCount, second: PinCount) {
        self.first = first
        self.second = second
    }
}

struct Pins {
    private enum Constants {
        static let maximumFallenPins = 10
        static let minimumFallenPins = 0
    }
    
    private enum Error: LocalizedError {
        case invalidValue
        
        var errorDescription: String? {
            switch self {
            case .invalidValue: return "쓰러진 볼링핀은 0개 이상이어야 합니다."
            }
        }
    }
    
    let fallendPins: Int
    
    init?(fallen: Int) {
        self.fallendPins = fallen
        guard (try? validate(fallen: fallen)) != nil else {
            return nil
        }
    }
    
    private func validate(fallen: Int) throws {
        guard (Constants.minimumFallenPins...Constants.maximumFallenPins).contains(fallen) else {
            throw Error.invalidValue
        }
    }
    
    static func bowl(fallendPins: Int) -> Pins {
        return Pins(fallen: fallendPins)!
    }
    
    func isStrike() -> Bool {
        fallendPins == Constants.maximumFallenPins
    }
    
    func isSpare(with pins: Pins) -> Bool {
        self.fallendPins + pins.fallendPins == Constants.maximumFallenPins
    }
}
