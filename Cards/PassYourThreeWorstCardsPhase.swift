//
//  PassYourThreeWorstCardPhase.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 30/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

public protocol RobotPasser
{
  
    func passCards() -> [PlayingCard]
    
}

open class PassYourThreeWorstCardsPhase
{
var players : [CardPlayer]
var scene : CardScene
var cardsPassed = [CardPile]()
public var isCurrentlyActive = true

    
    public init(scene : CardScene, players:[CardPlayer])
    {
        self.players = players
        self.scene = scene
        setPassedCards()
    }


    func setPassedCards()
    {
    cardsPassed.append(CardFan(name: CardPileType.passing.description))
    for _ in players
        {
        cardsPassed.append(CardPile(name: CardPileType.passing.description))
        }
    }
    func resetPassedCards()
    {
    
    for (cardTrioPassed,_) in zip(cardsPassed,players)
       {
       cardTrioPassed.cards = []
    }
    }
    public func setupCardPilesSoPlayersCanPassTheir3WorstCards()
    {
    for (passPile,player) in zip( cardsPassed, players )
      {
      let side = player.sideOfTable
    
      if let passFan = passPile as? CardFan
        {
        passFan.setup(scene, sideOfTable: SideOfTable.center, isUp: true, sizeOfCards: CardSize.medium)
        }
      else
        {
        passPile.setup(scene,
        direction: side.direction,
        position: side.positionOfPassingPile( 80, width: scene.frame.width, height: scene.frame.height),
        isUp: false)
        }
      }
   
    }
    public func arrangeLayoutFor(_ size:CGSize, bannerHeight:CGFloat)
    {
        for (passPile,player) in zip( cardsPassed, players )
        {
            let side = player.sideOfTable
            
            if let passFan = passPile as? CardFan
            {
               passFan.bannerHeight = bannerHeight
                passFan.tableSize = size
                passFan.rearrangeFast()
            }
            else
            {
                passPile.position = side.positionOfPassingPile( 80, width: size.width, height: size.height)
                passPile.bannerHeight = bannerHeight
                passPile.tableSize = size
                passPile.rearrangeFast()
            }
        }
    }
    func takePassedCards()
    {
    
      let noOfPlayer = players.count
      for (next,toPlayer) in  players.enumerated()
        {
    
        var previous = next - 1
        if previous < 0
          {
           previous = noOfPlayer - 1
          }
    
        let fromPlayersCards = cardsPassed[previous].cards
    
        cardsPassed[previous].clear()
        for card in fromPlayersCards
          {
          scene.cardSprite(card)!.player = toPlayer
          }
    
    
        toPlayer.appendContentsToHand(fromPlayersCards)
        }
      resetPassedCards()
    }
    
    func unpassCard(_ seatNo:Int, passedCard:PlayingCard) -> PlayingCard?
    {
      return players[seatNo]._hand.transferCardFrom(self.cardsPassed[seatNo], card: passedCard)
    }
    
    func passCard(_ seatNo:Int, passedCard:PlayingCard) -> PlayingCard?
    {
        return self.cardsPassed[seatNo].transferCardFrom(players[seatNo]._hand, card: passedCard)
    }
    
    func passOtherCards()
    {
    for (i,player) in  players.enumerated()
      {
      if let compPlayer = player as? RobotPasser
        {
        for card in compPlayer.passCards()
          {
          _ = passCard(i, passedCard:card)
          }
        }
      }
    }
    
    func endCardPassingPhase()
    {
        passOtherCards()
        takePassedCards()
        isCurrentlyActive  = false
        
    }
    
    public func transferCardSprite(_ cardsprite:CardSprite, isTargetHand:Bool) -> Bool
    {
        if let sourceFanName = cardsprite.fan?.name
        {
            if sourceFanName == CardPileType.hand.description  && isTargetHand
            {
                if let _ = passCard(0, passedCard: cardsprite.card)
                {
                    return true
                }
            }
            if sourceFanName == CardPileType.passing.description  && !isTargetHand
            {
                if let _ = unpassCard(0, passedCard: cardsprite.card)
                {
                    return true
                }
            }
        }
        
        return false
    }
    public func isPassingPhaseContinuing() -> Bool
    {
        let count = cardsPassed[scene.currentPlayer.playerNo].cards.count
      
        if  count < 3
          {
          Bus.send(GameNotice.discardWorstCards(3-count))
          return true
          }
        else
          {
          endCardPassingPhase()
          //  startTrickPhase()
          return false
          }
    }
}
