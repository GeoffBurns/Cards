//
//  GameNotice.swift
//  Cards
//
//  Created by Geoff Burns on 27/7/18.
//  Copyright © 2018 Geoff Burns. All rights reserved.
//

public protocol GameMove {
    var description : String? {get}
}

public protocol GameTip {
    var description : String {get}
}

public protocol PlayerScored {
    var description : String? {get}
}

public enum GameNotice : Equatable
{
    case winTrick(String)
    case winGame(String)
    case suiteFinished(PlayingCard.Suite)
    case player(PlayerScored)
    case invalidMove(GameMove)
    case validMove(GameMove)
    case waitYourTurn
    case turnOverYourCards
    case turnFor(CardPlayer)
    case showTip(GameTip)
    case newGame
    case newGame2(String)
    case discardWorstCards(Int)
    case discardWorstCards2(String,Int)
    
  
    public var description : String?
    {
        switch self
        {
        case .winTrick( let name ) :
            return  "%@ just Won the Trick".sayTo(name)
        case .winGame( let name ) :
            return "%@ just Won the Game".sayCongratsTo(name)
        case .suiteFinished(let suite) :
            return suite.description + " " + "Finished".localize
        case .turnOverYourCards :
            return "Swipe to turn over your cards".localize
        case .turnFor( let player ) :
            if player is HumanPlayer
            {
                return player.isYou
                    ? "Your Turn".localize
                    : "%@ Turn".localizeWith(player.name )
            } else { return nil }
        case .showTip( let tip ) :
            return tip.description
        case .newGame :
            return "Game On".localize
        case .newGame2(let game) :
            return "%@ Game On".localizeWith(game)
        case .invalidMove( let move )  :
            return move.description
        case .validMove( let move )  :
            return move.description
        case .player( let scored )  :
            return scored.description
        case .waitYourTurn :
            return "Wait your turn".localize
        case .discardWorstCards(let noOfCardsLeft) :
            switch noOfCardsLeft
            {
            case 3 :
                return "Discard Your".localize + "\n" + "Three Worst Cards".localize
            case 1 :
                return "Discard one more card".localize + "\n" + "Your worst card".localize
            default :
                return "Discard two more cards".localize + "\n" + "Your worst cards".localize
            }
        case .discardWorstCards2(let game, let noOfCardsLeft) :
            switch noOfCardsLeft
            {
            case 3 :
                //  return "Discard Your".localize + "\n" + "Three Worst Cards".localize
                return game + "\n" + "Discard 3 cards".localize
            case 1 :
                return "Discard one more card".localize + "\n" + "Your worst card".localize
            default :
                return "Discard two more cards".localize + "\n" + "Your worst cards".localize
            }
        }
    }
    
    public var line2 : String?
    {
        if let message = description {
            if message == "" {
                return ""
            }
            let messageLines = message.components(separatedBy: "\n")
            switch (messageLines.count) {
            case 1 :
                return message
            default :
                return messageLines[1]
            }
        }
        return nil
    }
    public var line1 : String?
    {
        if let message = description {
            if message == "" {
                return ""
            }
            let messageLines = message.components(separatedBy: "\n")
            switch (messageLines.count) {
            case 1 :
                return ""
            default :
                return messageLines[0]
            }
        }
        return nil
    }
}

public func ==(lhs: GameNotice, rhs: GameNotice) -> Bool {
    switch (lhs, rhs) {
        
    case let (.winTrick(la), .winTrick(ra)): return la == ra
    case let (.suiteFinished(la), .suiteFinished(ra)): return la == ra
    case let (.winGame(la), .winGame(ra)): return la == ra

    case let (.turnFor(la), .turnFor(ra)): return la == ra
    case let (.showTip(la), .showTip(ra)): return la == ra
    case let (.discardWorstCards(la), .discardWorstCards(ra)): return la == ra
    case let (.invalidMove(la), .invalidMove(ra)): return la == ra
    case let (.validMove(la), .validMove(ra)): return la == ra
    case let (.player(la), .player(ra)): return la == ra
    case (.waitYourTurn, .waitYourTurn): return true
    case (.newGame, .newGame): return true
        
    default: return false
    }
}


public func ==(lhs: GameMove, rhs:GameMove) -> Bool {
    return lhs.description == rhs.description
}
public func ==(lhs: GameTip, rhs:GameTip) -> Bool {
    return lhs.description == rhs.description
}
public func ==(lhs: PlayerScored, rhs: PlayerScored) -> Bool {
    return lhs.description == rhs.description
}
