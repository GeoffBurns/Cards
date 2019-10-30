//
//  CardStack.swift
//  Cards
//
//  Created by Geoff Burns on 30/10/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

/// How the cards are displayed in a stack
/// Only certain cards are accepted on the stack
/// Used in Sevens and Penalty Games
typealias ValidNextCardsCalculator = (PlayingCard) -> Set<PlayingCard>
typealias ValidNextCardCalculator = (PlayingCard) -> PlayingCard?

public class CardStack : CardPile
{
    public weak var parentStack : CardStack? = nil
    public var suite: PlayingCard.Suite = PlayingCard.Suite.spades
    public var baseCard : PlayingCard? = nil  { didSet { updateBase() } }
    var baseSprite : CardSprite? { if baseCard == nil {return nil}; return scene!.whiteCardSprite(baseCard!) }
    var validNextCardsCalculator : (PlayingCard) -> [PlayingCard] = CardStack.nextHigherCard
    public var lowerStack: CardStack? = nil
    public var x = 0
    public var y = 0
    
     public func updateBaseBackground()
     {
     if let white = self.baseSprite as? WhiteCardSprite
            {
                white.updateBackground()
            }
    }
        
    public static func nextLowerCard(_ lastCard:PlayingCard) ->[PlayingCard]
    {
            let prevcards = Game.deck.orderedDeck
                .filter { $0.suite == lastCard.suite && $0.value < lastCard.value }
                .sorted {$0.value > $1.value}
            
            return prevcards
    }

    public static func nextHigherCard(_ lastCard:PlayingCard) ->[PlayingCard]
    {
        
    let nextcards = Game.deck.orderedDeck
        .filter { $0.suite == lastCard.suite && $0.value > lastCard.value }
        .sorted {$0.value < $1.value}
        
    return nextcards
    }
    public override func discardAll()
    {
        if isBackground
        {
            discardAreas?.discardWhitePile.transferFrom(self)
        }
        else
        {
            discardAreas?.discardPile.transferFrom(self)
        }
        if let base = baseCard
        {
            discardAreas?.discardWhitePile.append( base  )
            baseCard = nil
        }
    }
 
    override func rotationOfCard(_ positionInSpread:CGFloat, fullHand:CGFloat) -> CGFloat
    {
        return 0
    }
    public func nextCard() -> PlayingCard?
    {

        if let last = cards.last
        {
            return self.validNextCardsCalculator ( last ).first
        }
        return baseCard
    }
    public var isFinished : Bool {
        
        
        if let last = cards.last
        {
            if self.validNextCardsCalculator ( last ).first == nil
            {
                return true
            }
        }
        return false
    }
    public var finished : CardStack? {
        
        if let parent = self.parentStack
        {
            return parent.finished
        }
        
        if let lower = lowerStack, isFinished && lower.isFinished
        {
            return self
        }
        return nil
    }
    public func playBefore(_ card:PlayingCard) -> PlayingCard?
    {
        if baseCard == nil {
            return nil }
        if baseCard!.suite != card.suite { return nil }
        
        if let next = nextCard(), next != card
           && Set(self.validNextCardsCalculator ( next )).contains(card)
            {
            return next
            }
        
        if let lower = lowerStack,
            let next = lower.nextCard(), next != card
                && Set(lower.validNextCardsCalculator ( next )).contains(card)
        {
            return next
        }
        
        return baseCard
        
    }
    
    public func addLower() ->CardStack
    {
        lowerStack = CardStack(name: CardPileType.stack.description)
        lowerStack!.validNextCardsCalculator = CardStack.nextLowerCard
        lowerStack!.parentStack = self
        return lowerStack!
    }
    public func updateAll()
    {
        updateBase()
        for (i,card) in cards.enumerated()
        {
            rearrangeFor(card, positionInSpread: CGFloat(i),  fullHand: 1)
        }
        
    }
    public override func update()
    {
        
        if !cards.isEmpty
        {
            if let lower = lowerStack, lower.baseCard == nil
            {
            lower.baseCard = Game.deck.lowerMiddleCardIn(self.baseCard!.suite)
            }
        }
        /// if its a pile instead of a fan you don't need to rearrange the pile for every change
    }
    //
    func updateBase()
    {
    
        if let sprite = baseSprite
        {
            sprite.fan = self
            
          //  if (sprite.state != CardState.AtRest)
          //  {
                sprite.zPosition = 1
                sprite.state = CardState.atRest
          //  }
            
            
            sprite.positionInSpread = 0
            
            // PlayerOne's cards are larger
            let newScale =  sizeOfCards.scale
            
            let newHeight = newScale * sprite.size.height / sprite.yScale
            sprite.updateAnchorPoint(cardAnchorPoint)
            sprite.color = UIColor.white
            sprite.colorBlendFactor = 0
            
            
            sprite.position =  positionOfCard(0, spriteHeight: newHeight, fullHand:fullHand)
            
            sprite.zRotation = rotationOfCard(0, fullHand:fullHand)
            sprite.setScale(sizeOfCards.scale)
            
        }
    }
}
