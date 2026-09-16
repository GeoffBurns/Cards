//
//  GameScene.swift
//  Cards
//
//  Created by Geoff Burns on 10/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//
import SpriteKit 

public protocol HasDiscardArea : AnyObject
{
    var discardPile : CardPile { get }
    var discardWhitePile : CardPile { get }
}

open class CardScene : SKScene, HasDiscardArea, PositionedOnTable  {
    
    open var discardPile = CardPile(name: CardPileType.discard.description)
    open var discardWhitePile = CardPile(name: CardPileType.discard.description)
    open var tableSize = CGSize()
    public var currentPlayer : CardPlayer = CardPlayer(name: "None")
    // Tasks started by the scene that should be cancelled when the scene is dismissed
    private var lifecycleTasks = [Task<Void, Never>]()
    
    open func setupCurrentPlayer()
    {
        // store the Task so it can be cancelled when the scene is torn down
        let t = Task { [weak self] in
            for await player in Bus.sharedInstance.events
                .asStream()
                .compactMap(\.turn) {
                    await MainActor.run {  [weak self] in
                        guard let self = self else { return }
                        Bus.send(GameNotice.turnFor(player))
                        self.currentPlayer = player
                    }
            }
        }
        lifecycleTasks.append(t)

    }
    open func setupSounds()
    {
        let t = Task { [weak self] in
            for await sound in Bus.sharedInstance.notices
                .asStream()
                .compactMap(\.sound) {
                    await MainActor.run {
                        // sound playing does not need the scene but keep weak self to avoid retains
                        _ = self
                        SoundManager.sharedInstance.playSounds(sound)
                    }
            }
        }
        lifecycleTasks.append(t)
    } 

    /// Cancel and clear any lifecycle tasks created by this scene
    public func cancelLifecycleTasks() {
        for t in lifecycleTasks { t.cancel() }
        lifecycleTasks.removeAll()
    }

    open override func willMove(from view: SKView) {
        super.willMove(from: view)
        // Tear down scene-owned tasks and singletons listening to streams
        cancelLifecycleTasks()
        StatusDisplay.sharedInstance.unregister()
        ScoreDisplay.sharedInstance.unregister()
    }

    deinit {
        cancelLifecycleTasks()
        StatusDisplay.sharedInstance.unregister()
        ScoreDisplay.sharedInstance.unregister()
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

public protocol HasDraggableCards : AnyObject
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


