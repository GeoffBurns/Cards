//
//  CardFan.swift
//  Cards
//
//  Created by Geoff Burns on 21/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

/// How the cards are displayed in a fan
/// Cards positions need to be calculated more frequently in a fan as opposed to a pile
public class CardFan : CardPile
{
    
     static let fanAnchorPoint = CGPoint(x: 0.5,y: -0.7)
     override var cardAnchorPoint : CGPoint { get { return CardFan.fanAnchorPoint }}
    

    public func seat(sideOfTable: SideOfTable, isUp: Bool, sizeOfCards: CardSize = CardSize.small)
    {
        self.sideOfTable = sideOfTable
        self.isUp = isUp
        self.sizeOfCards = sizeOfCards
        self.direction = sideOfTable.direction
        self.zPositon = self.sizeOfCards.zOrder
        self.position = CGPoint.zero
        self.isFanClosed = false

    }

    public override func normalizeCards(_ cards:[PlayingCard]) -> [PlayingCard]
    {
        return Array(cards.sorted().reversed())
    }
    public override func update()
    {
       layoutAnimated()
    }
    override func positionOfCard(_ positionInSpread:CGFloat, spriteHeight:CGFloat,fullHand:CGFloat) -> CGPoint
    {
        
        let result =  sideOfTable.positionOfCard(positionInSpread, spriteHeight: spriteHeight,
            width: tableSize.width, height: tableSize.height, fullHand:fullHand)
        return CGPoint(x: result.x,y: result.y + self.bannerHeight)
    }
    override func rotationOfCard(_ positionInSpread:CGFloat, fullHand:CGFloat) -> CGFloat
    {
        return direction.rotationOfCard(positionInSpread, fullHand:fullHand)
    }
    public override func rearrange()
    {
        if(scene==nil)
        {
            return
        }
        var fullHand = CardPile.defaultSpread
        let noCards = CGFloat(cards.count)
        var positionInSpread = CGFloat(0)
        
        if isFanOpen
        {
            positionInSpread = (fullHand - noCards + 1) * 0.5
            if fullHand < noCards
            {
                fullHand = noCards
                positionInSpread = CGFloat(0)
            }
        }
        for card in cards
        {
            rearrangeFor(card,positionInSpread:positionInSpread, fullHand:fullHand)
            positionInSpread += 1
            
        }
    }
    public override func rearrangeFast()
    {
        if(scene==nil)
        {
            return
        }
        var fullHand = CardPile.defaultSpread
        let noCards = CGFloat(cards.count)
        var positionInSpread = CGFloat(0)
        
        if isFanOpen
        {
            positionInSpread = (fullHand - noCards + 1) * 0.5
            if fullHand < noCards
            {
                fullHand = noCards
                positionInSpread = CGFloat(0)
            }
        }
        for card in cards
        {
            rearrangeFastFor(card,positionInSpread:positionInSpread, fullHand:fullHand)
            positionInSpread += 1
            
        }
    }
   
}

