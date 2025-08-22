//
//  GameEvent.swift
//  Cards
//
//  Created by Geoff Burns on 7/10/2015.
//  Copyright © 2018 Geoff Burns. All rights reserved.
//

public enum GameEvent : Equatable
{
    case newHand
    case turnFor(CardPlayer)

    
    public var description : String? {
        switch self
            {
            case .turnFor( let player ) :
                if player is HumanPlayer
                {
                    return player.isYou
                        ? "Your Turn".localize
                        : "%@ Turn".localizeWith(player.name )
                } else { return nil }

            case .newHand :
                return nil
            }
    }
    public var hand : Void? {
        self == .newHand ? () : nil
    }
    
    public var turn : CardPlayer? {
        if case let .turnFor(player) = self {
            return player
        }
        return nil
    }
}

public func ==(lhs: GameEvent, rhs: GameEvent) -> Bool {
    switch (lhs, rhs) {
        
    case let (.turnFor(la), .turnFor(ra)): return la == ra
    case (.newHand, .newHand): return true
        
    default: return false
    }
}


