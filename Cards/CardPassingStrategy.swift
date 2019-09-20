//
//  CardPassingStrategy.swift
//  Cards
//
//  Created by Geoff Burns on 16/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//


// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


// What Strategy does a computer player use when passing the 3 worst cards.
public protocol CardPassingStrategy
{
    func chooseWorstCards(_ player:CardHolder) -> [PlayingCard]
    
}
open class HighestCardsPassingStrategy : CardPassingStrategy
{
    public static let sharedInstance = HighestCardsPassingStrategy()
    fileprivate init() { }
    public func chooseWorstCards(_ player:CardHolder) -> [PlayingCard]
    {
        let orderedArray = player.hand.sorted(by: {$0.value > $1.value})
        let slice = orderedArray[0...2]
        return Array(slice)
    }
}
open class HighLowCardsPassingStrategy : CardPassingStrategy
{
    public static let sharedInstance = HighLowCardsPassingStrategy()
    fileprivate init() { }
    public func chooseWorstCards(_ player:CardHolder) -> [PlayingCard]
    {
        
        var ranksForCards: Dictionary<PlayingCard,Int> = Dictionary<PlayingCard,Int>()
    
        for suite in PlayingCard.Suite.allSuites
            {
                
                let suiteCards = player.hand.filter { $0.suite == suite }.sorted()
                for card in suiteCards
               {
        
                let midCard = Game.deck.middleCardIn(card.suite)
                
                if let midIdx = suiteCards.firstIndex(of: midCard),
                    let cardIdx = suiteCards.firstIndex(of: card)
                  {
                    let rank = abs(cardIdx-midIdx)
                    ranksForCards[card] = rank
                   
                  }
                }
            
           
        }

        let orderedArray = player.hand.sorted(by: {ranksForCards[$0] > ranksForCards[$1]})
        let slice = orderedArray[0...2]
        return Array(slice)
    }
}

// TODO an alternative strategy is creating a suite with few cards
/*
public class ShortSuitePassingStrategy : CardPassingStrategy
{
static let sharedInstance = ShortSuitePassingStrategy()
private init() { }
func chooseWorstCards(player:CardHolder) -> [PlayingCard]
{

return result
}
}
*/
// TODO an alternative strategy is to get rid of cards form suites where your lowest card is high
/*
public class ProtectHighMiniumSuitePassingStrategy : CardPassingStrategy
{
static let sharedInstance = ProtectHighMiniumSuitePassingStrategy()
private init() { }
func chooseWorstCards(player:CardHolder) -> [PlayingCard]
{

//return result
}
}*/
