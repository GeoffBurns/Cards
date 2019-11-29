//
//  GameScene.swift
//  Cards
//
//  Created by Geoff Burns on 10/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import SpriteKit
import RxSwift

public protocol HasDiscardArea : class
{
    var discardPile : CardPile { get }
    var discardWhitePile : CardPile { get }
}

open class CardScene : SKScene, HasDiscardArea, PositionedOnTable  {
    
    open var discardPile = CardPile(name: CardPileType.discard.description)
    open var discardWhitePile = CardPile(name: CardPileType.discard.description)
    open var tableSize = CGSize()
    public var currentPlayer : CardPlayer = CardPlayer(name: "None")
    private let disposeBag = DisposeBag()
    
    open func setupCurrentPlayer()
    {
        
       let _ = Bus.sharedInstance.events
                    .asObservable()
                    . filter { switch $0 {case .turnFor: return true; default: return false } }
                     .subscribe(onNext: {  switch $0 {
                               case GameEvent.turnFor(let player) :
                                   Bus.send(GameNotice.turnFor(player))
                                   self.currentPlayer = player
                               default : break
                     }
                     })
                     .disposed(by: disposeBag)
 
    }
    open func setupSounds()
    {
    let _ = Bus.sharedInstance.notices
                    .asObservable()
                    .filter { $0.sound.count > 0 }
                    .subscribe(onNext: {  /* [weak self] */ value in
                                        SoundManager.sharedInstance.playSounds(value.sound)
                    })
                    .disposed(by: disposeBag)
          
    }
}

extension HasDiscardArea
{
    public func setupDiscardArea()
    {
        
        discardWhitePile.isBackground = true
        discardPile.setup(self)
        discardWhitePile.setup(self)
        discardPile.setPosition(direction: Direction.up, position: CGPoint(x: -300, y: -300),isUp: false)
              discardWhitePile.setPosition( direction: Direction.up, position: CGPoint(x: -300, y: -300),isUp: false)
            
        
//        discardPile.isDiscard = true
//        discardWhitePile.isDiscard = true
        discardWhitePile.speed = 0.1
    }
}
public protocol HasDealersArea : HasDiscardArea
{
    var dealtPiles : [CardPile] { get set }
    
}
public protocol PositionedOnTable
{
     var tableSize : CGSize { get set }
    
}

extension CGSize
{
      public var isPortrait : Bool { return self.width < self.height }
}

extension PositionedOnTable
{
    public var isPortrait : Bool { return tableSize.isPortrait }
}

extension HasDealersArea
{
    public func setupDealersAreaFor(_ noOfPlayers:Int,size:CGSize)
    {
        let width = size.width
        let height = size.height
        setupDealersAreaFor(noOfPlayers,width: width , height: height )
    }
    public func setupDealersAreaFor(_ noOfPlayers:Int,width: CGFloat , height: CGFloat )
    {
        dealtPiles = []
        let hSpacing = CGFloat(noOfPlayers) * 2
        let directions = [Direction.down,Direction.right,Direction.right,Direction.up,Direction.up,Direction.left,Direction.left,Direction.left,Direction.left,Direction.left,Direction.left]
        for i in 0..<noOfPlayers
        {
            let dealtPile = CardPile(name: CardPileType.dealt.description)
            dealtPile.setup(self)
            dealtPile.setPosition(direction: directions[i], position: CGPoint(x: width * CGFloat(2 * i  - 3) / hSpacing,y: height*1.2), isUp: false)
            dealtPile.speed = 0.1
            dealtPiles.append(dealtPile)
        }
        
    }
    public func deal(_ hands:[[PlayingCard]])
    {
        for (dealtPile,hand) in zip(dealtPiles,hands)
        {
            dealtPile.replaceWithContentsOf(hand)
        }
    }
}

public protocol HasBackgroundSpread : HasDiscardArea
{
    var backgroundFan : CardFan { get }
    
}
public protocol HasDemoMode
{
    func resetSceneAsDemo()
    var isInDemoMode  : Bool { get }
}

public protocol HasMusic
{
    func stopMusic()
    func playMusic(_ n: Int)
}
extension HasBackgroundSpread
{
    public func setupBackgroundSpread( )
    {
        backgroundFan.isBackground = true
        backgroundFan.setup(self)
        backgroundFan.seat(sideOfTable: SideOfTable.center, isUp: true, sizeOfCards: CardSize.medium)
        backgroundFan.zPositon = 0.0
        backgroundFan.speed = 0.1
    }
    public func fillBackgroundSpreadWith(_ cards:[PlayingCard])
    {
        backgroundFan.discardAll()
        backgroundFan.replaceWithContentsOf(cards)
    }
}

public protocol HasDraggableCards : class
{

    var draggedNode: CardSprite? { get set }
}

extension HasDraggableCards
{
    public func restoreDraggedCard()
    {
        if let cardsprite = draggedNode
            
        {
            cardsprite.setdown()
            draggedNode=nil
        }
    }
    public func quickSwapDraggedCard(_ newCard:CardSprite,originalPosition:CGPoint)
    {
    draggedNode?.setdownQuick()
    newCard.liftUpQuick(originalPosition)
    draggedNode = newCard;
    }
    public func startDraggingCard(_ newCard:CardSprite,originalPosition:CGPoint)
    {
    draggedNode = newCard
    newCard.liftUp(originalPosition)
    }
}


