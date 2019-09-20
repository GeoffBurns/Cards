//
//  GameSetting.swift
//  Cards
//
//  Created by Geoff Burns on 22/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

public enum DeviceType
{
    case phone
    case pad
    case bigPhone
    case bigPad
}
public enum LayoutType
{
    case phone
    case pad
    case portrait
}

public protocol ICardGameSettings
{
    var noOfSuitesInDeck : Int { get }
    var noOfSuitesDefault : Int { get set }
    var noOfPlayersAtTable  : Int { get }
    var noOfHumanPlayers : Int { get }
    var noOfCardsInASuite  : Int { get }
    var hasTrumps  : Bool { get }
    var hasJokers : Bool { get set}
    var hasFool : Bool { get }
    var isFoolATrump : Bool { get set}
    var showTips : Bool { get }
    var willPassCards  : Bool { get }
    var useNumbersForCourtCards : Bool { get }
    var isAceHigh  : Bool { get set}
    var makeDeckEvenlyDevidable  : Bool { get }
    var speedOfToss  : Int { get }
    var tossDuration : TimeInterval { get  }
    var memoryWarning : Bool { get set }
    var noOfTrumps : Int { get }
    var noOfStandardTrumps : Int { get }
    var noOfJokers : Int { get }
    var specialSuite : PlayingCard.Suite { get }
    var options : [SaveableOption]  { get set}
    func changed() -> Bool
    func clearData(_ : Int) -> Void
    func cacheSpeed(_ : Int) -> Void
}

enum GameProperties : String
{
    case NoOfSuitesInDeck = "NoOfSuitesInDeck"
    case noOfHumanPlayers = "NoOfHumanPlayers"
    case NoOfPlayersAtTable = "NoOfPlayersAtTable"
    case NoOfCardsInASuite = "NoOfCardsInASuite"
    case HasTrumps = "HasTrumps"
    case HasJokers = "HasJokers"
    case willPassCards = "willPassCards"
    case ignorePassCards = "ignorePassCards"
    case useNumbersForCourtCards = "useNumbersForCourtCards"
    case speedOfToss = "speedOfToss"
    case memoryWarning = "memoryWarning"
    case hideTips = "hideTips"
}

/// User controlled options for the game
open class DeviceSettings
{
    public static var isPad : Bool
    {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
    public static var isPhone : Bool
    {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }
    public static var isPortrait : Bool
    {
        let size = UIScreen.main.applicationFrame
        return size.width < size.height
    }
    public static var isPhoneX : Bool
    {
        return UIScreen.main.nativeBounds.height == 2436
    }
    public static var isPhone55inch : Bool
    {
        return UIScreen.main.nativeBounds.height == 2208
    }
    
    public static var isPadPro : Bool
    {
        let size = UIScreen.main.applicationFrame
        return size.width > 1250 || size.height > 1250
    }
    public static var isBigPhone : Bool
    {
        return   UIScreen.main.nativeScale > 2.5
    }
    public static var isBigPad : Bool
    {
        return   isPad && UIScreen.main.nativeScale > 1.9
        
    }
    public static var isBiggerDevice: Bool
    {
        return isBigPhone || isBigPad
    }
    public static var isBigDevice: Bool
    {
        return isBigPhone || isPad
    }
    public static var isSmallDevice: Bool
    {
        return !isBigPhone && !isPad
    }
    public static  var device : DeviceType {
        
        if isPad
        {
            if isBigPad
            {
                return .bigPad
            }
            return .pad
        }
        if isBigPhone
        {
            return .bigPhone
        }
        return .phone
    }
    public static  var layout : LayoutType {
        
        if isPad
        {
            if isPortrait
            {
                return .portrait
            }
            return .pad
        }
        return .phone
    }
}

public class Options
{
    public static var memoryWarning = YesNoOption(inverted: false, prompt: "Memory Warning", key: GameProperties.memoryWarning)

    public static var noOfSuites = RangeOption(min: 3, max: 8, defaultValue: 5, prompt: "Number Of Suites", key: GameProperties.NoOfSuitesInDeck)

    public static var noOfPlayers = RangeOption(min: 3, max: (DeviceSettings.isPad ? 7 : 6), defaultValue: 4, prompt: "Number Of Players", key: GameProperties.NoOfPlayersAtTable)
    
    public static var noOfHumans = RangeOption(min: 1, max: (DeviceSettings.isPad ? 7 : 6), defaultValue: 1, prompt: "Number of Human Players", key: GameProperties.noOfHumanPlayers)

    public static var noOfCards = RangeOption(min: 10, max: 20, defaultValue: 14, prompt: "Number In Suite", key: GameProperties.NoOfCardsInASuite)

    public static var showTips = YesNoOption(inverted: true, prompt: "Show Tips", key: GameProperties.hideTips)
 
    public static var passCard = YesNoOption(inverted: true, prompt: "Pass Worst Cards", key: GameProperties.ignorePassCards)

    public static var useNumbers = YesNoOption(inverted: false, prompt: "Use Numbers For Court Cards", key: GameProperties.useNumbersForCourtCards)
    
    public static var speed = SelectOption( selections: ["Very Slow",
                                                   "Slow",
                                                   "Normal",
                                                   "Fast",
                                                   "Very Fast"], defaultValue: 3, prompt: "Speed Of Cards", key: GameProperties.speedOfToss)
    
    public static var trumps = YesNoOption(inverted: false, prompt: "Include Tarot Trumps", key: GameProperties.HasTrumps)

    public static var jokers = YesNoOption(inverted: false, prompt: "Include Jokers", key: GameProperties.HasJokers)
}

class Silent : GameTip {
    var description = ""
    
    static var Tip = Silent()

}

public class Game
{
    public static var settings : ICardGameSettings = LiveGameSettings(options: [])
    static var _deck  : PlayingCard.BuiltCardDeck? = nil

    public static var deck  : PlayingCard.BuiltCardDeck {
     
        if _deck == nil { newDeck() }
        return _deck!
      
    }
    
    public static func newDeck() {
        _deck = PlayingCard.BuiltCardDeck(gameSettings: settings)
    }
    public static func newDeck(with: ICardGameSettings) {
        _deck = PlayingCard.BuiltCardDeck(gameSettings: with)
    }
    public static var backgroundColor = UIColor(red: 0.0, green: 0.5, blue: 0.2, alpha: 1.0)
    
    /// Tips shown in demo mode
    public static var demoTips : [GameTip] = []
    
    /// Tips shown in game mode
    public static var gameTips : [GameTip] = []
    
    /// current tips displayed
    public static var tips = demoTips
    
    /// last tip displayed
    static var lastTip  : GameTip = Silent.Tip
    
    /// next tip displayed
    static func nextTip()->GameTip
    {
        var result : GameTip = Silent.Tip
        
        repeat {
            result = tips.randomItem!
        } while result==lastTip
        
        lastTip = result
        
        return result
    }
}

/// User controlled options for the game
public class LiveGameSettings : ICardGameSettings
{

    
    public var options: [SaveableOption]

    public var specialSuite: PlayingCard.Suite  = PlayingCard.Suite.none
    public var isFoolATrump = false
    public var noOfJokers = 2
    public var noOfStandardTrumps = 21
    public var noOfTrumps: Int { return hasFool ? noOfStandardTrumps + 1 : noOfStandardTrumps }
    public var isAceHigh =  true
    public var hasFool =  true
    public var makeDeckEvenlyDevidable  =  true
    public var noOfSuitesDefault : Int  = 5
    
    public init(options: [SaveableOption])
    {
        self.options = options
    }
    public var memoryWarning : Bool {
        
        get { return Options.memoryWarning.value }
        set (newValue) { Options.memoryWarning.value = newValue }
    }

    public var noOfSuitesInDeck : Int {
        
      get { return Options.noOfSuites.value }
      set (newValue) { Options.noOfSuites.value = newValue }
    }
    
    public var noOfPlayersAtTable : Int {
            get { return Options.noOfPlayers.value }
            set (newValue) { Options.noOfPlayers.value = newValue }
    }
    
    public var noOfHumanPlayers : Int {
        get { return Options.noOfHumans.value }
        set (newValue) { Options.noOfHumans.value = newValue }
    }

    public var noOfCardsInASuite : Int {
        get { return Options.noOfCards.value }
        set (newValue) { Options.noOfCards.value = newValue }
    }

    public var showTips : Bool {
        get { return Options.showTips.value }
        set (newValue) { Options.showTips.value = newValue }
    }
    
    public var willPassCards : Bool {
        get { return Options.passCard.value }
        set (newValue) { Options.passCard.value = newValue }
    }
    
    public var useNumbersForCourtCards : Bool {
      get { return Options.useNumbers.value }
      set (newValue) {Options.useNumbers.value = newValue }
    }

    var __speedOfToss : Int? = nil
    var _speedOfToss :  Int {
       get { return Options.speed.value }
       set (newValue) { Options.speed.value = newValue }
    }
    public var speedOfToss : Int {
        get {
            if __speedOfToss == nil
            {
                __speedOfToss = _speedOfToss
            }
            if __speedOfToss! > 0 && __speedOfToss! < 8
            {
                return __speedOfToss!
            }
            return 3
        }
        set (newValue) {
            __speedOfToss = newValue
            _speedOfToss = newValue
        }
    }
    public func cacheSpeed(_ newValue:Int) { __speedOfToss = newValue }
    var tossDurations : [TimeInterval] = [ 1.0, 0.85, 0.7, 0.5, 0.4, 0.25, 0.18, 0.15, 0.1, 0.05]
    public var tossDuration : TimeInterval { return tossDurations[speedOfToss] }
    
 
    public var coin : Bool
    {
        return 0 == 2.random
    }

    var trumpsToggle = YesNoOption(inverted: false, prompt: "Include Tarot Trumps", key: GameProperties.HasTrumps)
    public var hasTrumps : Bool {
        
        get { return trumpsToggle.value }
        set (newValue) { trumpsToggle.value = newValue }
    }
 
    var jokerToggle = YesNoOption(inverted: false, prompt: "Include Jokers", key: GameProperties.HasJokers)
    public var hasJokers : Bool {
        get { return jokerToggle.value }
        set (newValue) { jokerToggle.value = newValue }
    }
    
    public func changed() -> Bool
    {
        return changed(settings:options);
    }
    func changed(settings:[SaveableOption]) -> Bool
    {
        if settings.hasAnyChanged { settings.saveAll() ; Game.newDeck(with: self) ; return true }
        return false
    }
    
    public var data : AnyObject? = nil
    
    public func clearData(_ newValue:Int) {  data = nil }

 }

