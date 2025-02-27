//
//  BowlingGameStateDelegate.swift
//  Bowling
//
//  Created by nylah.j on 2022/05/30.
//

import Foundation

protocol BowlingGameStateDelegate {
    func afterReceivePinCount(playerName: PlayerName, scoreBoard: ScoreBoard)
    func afterReceivePinCount(playerName: PlayerName, scoreBoard: Frame)
}

