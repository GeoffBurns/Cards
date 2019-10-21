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
//var currentPlayerNo : Int = 0
public var isCurrentlyActive = true

    
    public init(scene : CardScene, players:[CardPlayer])
    {
        self.players = players
        self.scene = scene
       // currentPlayerNo = 0
        setPassedCards()
    }


    func setPassedCards()
    {
    for p in players
        {
         if p is HumanPlayer
         {
            cardsPassed.append(CardFan(name: CardPileType.passing.description))
         }
            else
         {
            cardsPassed.append(CardPile(name: CardPileType.passing.description))
         }
        }
    }
    func resetPassedCards()
    {
    
    for (cardTrioPassed,_) in zip(cardsPassed,players)
       {
       cardTrioPassed.cards = []
    }
    }
    public func showPassPile(_ playerNo:Int)
    {
        if let passFan = cardsPassed[playerNo] as? CardFan
             {
             passFan.seat(sideOfTable: SideOfTable.center, isUp: true, sizeOfCards: CardSize.medium)
             }
    }
    public func hidePassPile(_ playerNo:Int)
    {
        if let passFan = cardsPassed[playerNo] as? CardFan
             {

                passFan.seat(sideOfTable: SideOfTable.hidden, isUp: false, sizeOfCards: CardSize.small)
                
        /*        let player = players[playerNo]
                 let side = player.sideOfTable
                 passFan.sideOfTable = side
                 passFan.setPosition(
                         direction: side.direction,

                         position: CGPoint(x: scene.frame.width*5 ,y: scene.frame.height*10),
                     //    position: side.positionOfPassingPile( 80, width: scene.frame.width, height: scene.frame.height),
                         isUp: false) */
             }
    }
    public func setupCardPilesSoPlayersCanPassTheir3WorstCards()
    {
    for (passPile,player) in zip( cardsPassed, players )
      {
      let side = player.sideOfTable
    
      if let passFan = passPile as? CardFan
        {
            passFan.setup(scene)
            if player.playerNo == Game.currentOperator
            {
            passFan.seat(sideOfTable: SideOfTable.center, isUp: true, sizeOfCards: CardSize.medium)
            } else
            {
                passFan.setPosition(
                    direction: side.direction,
                    position: CGPoint(x: scene.frame.width*0.20 ,y: scene.frame.height*1.3),
              //      position: side.positionOfPassingPile( 260, width: scene.frame.width, height: scene.frame.height),
                    isUp: false)
            }
        }
      else
        {
        passPile.setup(scene)
        passPile.setPosition(
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
      return players[seatNo]._hand.safeTransferCardFrom(self.cardsPassed[seatNo], card: passedCard)
    }
    
    func passCard(_ seatNo:Int, passedCard:PlayingCard) -> PlayingCard?
    {
        return self.cardsPassed[seatNo].safeTransferCardFrom(players[seatNo]._hand, card: passedCard)
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
    
    public func endCardPassingPhase()
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
                if let _ = passCard(Game.currentOperator, passedCard: cardsprite.card)
                {
                    return true
                }
            }
            if sourceFanName == CardPileType.passing.description  && !isTargetHand
            {
                if let _ = unpassCard(Game.currentOperator, passedCard: cardsprite.card)
                {
                    return true
                }
            }
        }
        return false
    }
 
    public func isPlayerPassing() -> Bool
    {
         //cardsPassed[scene.currentPlayer.playerNo]
        let passpile = cardsPassed[Game.currentOperator]
        let count = passpile.cards.count
      
        if  count < 3
          {
          Bus.send(GameNotice.discardWorstCards(3-count))
          return true
          }
        
        let side = SideOfTable.bottom // scene.currentPlayer.sideOfTable
        passpile.setPosition(
                direction: side.direction,
                position: side.positionOfPassingPile( 80, width: scene.frame.width, height: scene.frame.height),
                isUp: false)
        
        return false
    }
}
