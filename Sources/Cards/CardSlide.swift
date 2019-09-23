//
//  CardSlide.swift
//  Cards
//
//  Created by Geoff Burns on 1/10/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

/// How the cards are displayed in a slide
/// Cards positions need to be calculated more frequently in a slide as opposed to a pile
/// No rotation is needed unlike a fan

public class CardSlide : CardPile
{
    
    var slideWidth = CGFloat()
    
    public func setup(_ scene:HasDiscardArea, slideWidth: CGFloat, sizeOfCards: CardSize = CardSize.medium)
    {
        self.discardAreas = scene
        self.scene = scene as? SKNode
        self.sideOfTable = SideOfTable.bottom
        self.slideWidth = slideWidth
        self.isUp = true
        self.sizeOfCards = sizeOfCards
        self.direction = Direction.up
        self.zPositon = self.sizeOfCards.zOrder
    }
    
    public override func append(_ card:PlayingCard)
    {
        var updatedCards = cards
        updatedCards.append(card)
        let sortedHand = updatedCards.sorted()
        cards = ( Array(sortedHand.reversed()))
    }
    public override func update()
    {
        rearrange()
    }
    override func positionOfCard(_ positionInSpread:CGFloat, spriteHeight:CGFloat,fullHand:CGFloat) -> CGPoint
    {
        let seperation = max (CardPile.defaultSpread , CGFloat(cards.count))
        return CGPoint(x:position.x+slideWidth*positionInSpread/seperation, y:position.y)
    }
    public override func rotationOfCard(_ positionInSpread:CGFloat, fullHand:CGFloat) -> CGFloat
    {
        return 0.0
    }
    public override func appendContentsOf(_ newCards:[PlayingCard])
    {
        var updatedCards = cards
        updatedCards.append(contentsOf: newCards)
        let sortedHand = updatedCards.sorted()
        cards = ( Array(sortedHand.reversed()))
    }
    public override func replaceWithContentsOf(_ newCards:[PlayingCard])
    {
        let updatedCards = newCards
        let sortedHand = updatedCards.sorted()
        cards = ( Array(sortedHand.reversed()))
    }
    public override func rearrange()
    {
        if(scene==nil)
        {
            return
        }
        
        let noCards = CGFloat(cards.count)
        
        
        for (positionInSpread,card) in cards.enumerated()
        {
            rearrangeFor(card,positionInSpread:CGFloat(positionInSpread), fullHand:noCards)
            
            
        }
    }
    
}

