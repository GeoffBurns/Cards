//
//  CardPlayer.swift
//  Cards
//
//  Created by Geoff Burns on 11/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import SpriteKit
import ReactiveSwift


// Cut down version of a CardPlayer that is visible to tests
public protocol CardHolder
{
    func cardsIn(_ suite:PlayingCard.Suite) -> [PlayingCard]
    
    var hand : [PlayingCard] { get }
}

extension CardHolder
{
    public var RicketyKate : PlayingCard?
        {
            let RicketyKate = hand.filter { $0.isRicketyKate}
            
            return RicketyKate.first
    }
}
extension Sequence where Iterator.Element == PlayingCard
{
public func cardsIn(_ suite:PlayingCard.Suite) -> [PlayingCard]
{
    return self.filter {suite == $0.suite}
}
    
    public func cardsNotIn(_ suite:PlayingCard.Suite) -> [PlayingCard]
    {
        return self.filter {suite != $0.suite}
    }
}


open class NoPlayer:  CardHolderBase
{
    init() {
        super.init(name: "Played")
    }
}
open class CardHolderBase :  CardHolder
{
    open var name : String = "Base"
    open var sound : String = "Base"
    open var isYou : Bool { return name=="You".localize }
    public lazy var _hand : CardFan = CardFan(name: CardPileType.hand.description, player:self)
    open var hand : [PlayingCard] { get { return _hand.cards } set { _hand.cards = newValue }}
    open func cardsIn(_ suite:PlayingCard.Suite) -> [PlayingCard]
    {
        return _hand.cards.filter {$0.suite == suite}
    }
    
    public init(name s: String) {
        self.name = s
        self.sound = s
    }
    public init(name n: String, sound s: String) {
        self.name = n
        self.sound = s
    }
    open func removeFromHand(_ card:PlayingCard) -> PlayingCard?
    {
        return _hand.remove(card)
    }
}



// Models the state and behaviour of each of the players in the game
open class CardPlayer :CardHolderBase , Equatable, Hashable
{
    //////////////////////////////////////
    /// Variables
    //////////////////////////////////////
    // public var score : Int = 0
    public var currentTotalScore  = MutableProperty<Int>(0)
    public var isSetup = false
    public var noOfWins = MutableProperty<Int>(0)
    public var scoreForCurrentHand = 0
    open var sideOfTable = SideOfTable.bottom
    open var tempSide = SideOfTable.bottom
    public var playerNo = 0
    public var seatNo = 0
    public var wonCards : CardPile = CardPile(name: CardPileType.won.description)
 

    
    ///////////////////////////////////////
    /// Hashable Protocol
    ///////////////////////////////////////
    open var hashValue: Int {
        return self.name.hashValue
    }
    public func hash(into hasher: inout Hasher) {
        
        self.name.hash(into:&hasher)
       // hasher = self.name.hashValue
    }
    /////////////////////////////////
    /// Constructors and setup
    /////////////////////////////////
    public func setupCardPlayer(_ scene: CardScene, playerNo: Int)
    {
        
        self.isSetup = true
        self.playerNo = playerNo
        _hand.setup(scene)
        wonCards.setup(scene)
    }
    public func seatCardPlayer(_ scene: CardScene, sideOfTable: SideOfTable, isPortrait: Bool)
      {
      
        var isInDemoMode = false
        if let demoable = scene as? HasDemoMode
        {
            isInDemoMode = demoable.isInDemoMode
        }
        let isCardsShown = ((Game.settings.noOfHumanPlayers < 2 && self is HumanPlayer) ||
                isInDemoMode)
          seatCardPlayer(scene , sideOfTable: sideOfTable, isPortrait: isPortrait, isCardsShown: isCardsShown)
        
      }
    
    public func seatCardPlayer(_ scene: CardScene, sideOfTable: SideOfTable, isPortrait: Bool, isCardsShown: Bool)
      {
        self.sideOfTable = sideOfTable
        let isUp = sideOfTable == SideOfTable.bottom && isCardsShown
          let cardSize = sideOfTable == SideOfTable.bottom ? (isPortrait ? CardSize.medium :CardSize.big) : CardSize.small
          _hand.seat(sideOfTable: sideOfTable, isUp: isUp, sizeOfCards: cardSize)
          wonCards.setPosition(direction: sideOfTable.direction, position: sideOfTable.positionOfWonCards(scene.frame.width, height: scene.frame.height))
        
        _hand.rearrangeFast()
        wonCards.rearrangeFast()
        
      }
    
    

    public func turnOverCards()
    {
        _hand.isUp = true
        _hand.rearrangeFast()

    }
/*    public func setPosition(_ size:CGSize, sideOfTable: SideOfTable)
    {
        if self.isSetup
        {
            _hand.tableSize = size
            
            self.sideOfTable = sideOfTable
            _hand.sideOfTable = sideOfTable
            _hand.direction = sideOfTable.direction
            
            let isPortrait = size.width < size.height
            let isUp = sideOfTable == SideOfTable.bottom
            _hand.sizeOfCards = isUp ? (isPortrait ? CardSize.medium :CardSize.big) : CardSize.small
            wonCards.position = sideOfTable.positionOfWonCards(size.width, height: size.height)
            wonCards.tableSize = size
      //      wonCards.update()
      //      _hand.update()
        }
    }
 */
    ///////////////////////////////////
    /// Instance Methods
    ///////////////////////////////////
    
    open func newHand(_ cards: [PlayingCard]  )
    {
        _hand.replaceWithContentsOf(cards)
    }
    
    open func appendContentsToHand(_ cards: [PlayingCard]  )
    {
        _hand.appendContentsOf(cards);
    }
    
}

open class HumanPlayer :CardPlayer
{
    public init() {
        
        let helper = GameKitHelper.sharedInstance
        let name = helper.displayName
        super.init(name: name)
    }
    
    public override init(name:String,sound:String) {
        super.init(name: name, sound: sound)
    }
}



open class FakeCardHolder : CardHolderBase
{

    
    //////////
    // internal functions
    //////////
    open func addCardsToHand(_ cardCodes:[String])
    {
        hand.append(contentsOf: cardCodes.map { $0.card } )
    }
    
    public init() {
        super.init(name: "Fake")
    }
    
}
////////////////////////////////////////////////////////////
/// Equatable Protocol
///////////////////////////////////////////////////////////

public func ==(lhs: CardPlayer, rhs: CardPlayer) -> Bool
{
    return lhs.name == rhs.name
}
