//
//  ScorerType.swift
//  Cards
//
//  Protocol for scoring service used by games
//

import Foundation

public protocol ScorerType: AnyObject {
    func setupScorer(_ players: [CardPlayer])
    func playerThatWon(_ gameState: GameStateBase) -> CardPlayer?
    func recordTheScoresForAGameWin(_ winner: CardPlayer)
    func hasShotTheMoon() -> Bool
    var leaderboardScore: Int64 { get }
    func hasGameBeenWon()
    func endHand()
    func trickWon(_ gameState: GameStateBase) -> CardPlayer?
}
