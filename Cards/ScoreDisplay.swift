//
//  ScoreDisplay.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 18/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit
import ReactiveSwift


// Display the score for each player
public class ScoreDisplay
{
    public var scoreLabel = [SKLabelNode]()
    var players = [CardPlayer]()
    public static var top : CGFloat { get { return DeviceSettings.isPortrait ? 0.893 : 0.873 } }
    public static var _bottom : ()->CGFloat = {
        let isBig = DeviceSettings.isBigPro
        let bottom : CGFloat = DeviceSettings.isPortrait ? ( isBig ? 0.09 : 0.115) :
            (DeviceSettings.isPhone
                ?  0.19
                : ( isBig ? 0.16 : 0.23))
        return bottom
        
    }
    public static var bottom  : CGFloat { get {
        

        let isBig = DeviceSettings.isBigPro
        let bottom : CGFloat = DeviceSettings.isPortrait ? ( isBig ? 0.09 : 0.115) :
            (DeviceSettings.isPhone
                ?  0.19
                : ( isBig ? 0.16 : 0.23))
        return bottom
      //  return _bottom()
        
        }}
   /* ScoreDisplay.bottom =  DeviceSettings.isPortrait ? 0.12 :
    (DeviceSettings.isPhone
    ? (DeviceSettings.isPhoneX || DeviceSettings.isPhone55inch ? 0.25 : 0.19)
    : 0.22) */
    public static let sharedInstance = ScoreDisplay()
    fileprivate init() { }
    
    public static var scoreToString : (String,Int,Int) -> String =  {(_,_,_) in  return "" }
    static func register(_ scene: SKNode, players: [CardPlayer])
    {
        ScoreDisplay.sharedInstance.setupScoreArea(scene, players: players)
    }
    
    public static func scorePosition(_ side:SideOfTable, size: CGSize, bannerHeight:CGFloat) -> CGPoint
    {
        
        let top : CGFloat =  ScoreDisplay.top
        let bottom : CGFloat =  ScoreDisplay.bottom

    let noOfPlayers = Game.settings.noOfPlayersAtTable
    switch side
        {
        case .right:
            return CGPoint(x:size.width * 0.93, y:size.height * 0.5 + bannerHeight)
        case .rightLow:
            return CGPoint(x:size.width * 0.93, y:size.height * 0.35 + bannerHeight)
        case .rightHigh:
            return CGPoint(x:size.width * 0.93, y:size.height * 0.70 + bannerHeight)
        case .top:
            return  CGPoint(x:size.width * 0.5, y:size.height *  top + bannerHeight)
        case .topMidRight:
            return CGPoint(x:size.width * ( noOfPlayers == 6 ? 0.8 : 0.7), y:size.height *  top  + bannerHeight)
        case .topMidLeft:
            return CGPoint(x:size.width *  ( noOfPlayers == 6 ? 0.2 : 0.3), y:size.height *  top + bannerHeight)
        case .left:
            return CGPoint(x:size.width * 0.07, y:size.height * 0.5 + bannerHeight)
        case .leftLow:
            return CGPoint(x:size.width * 0.07, y:size.height * 0.35 + bannerHeight)
        case .leftHigh:
            return CGPoint(x:size.width * 0.07, y:size.height * 0.70 + bannerHeight)
        default:
            return  CGPoint(x:size.width * 0.5, y:size.height *  bottom + bannerHeight)
        }
    }
    public static func scoreRotation(_ side:SideOfTable) -> CGFloat
    {
        switch side
        {
        case .rightHigh:
            fallthrough
        case .rightLow:
            fallthrough
        case .right:
            return 90.degreesToRadians
        case .top:
            fallthrough
        case .topMidRight:
            fallthrough
        case .topMidLeft:
               return 0.degreesToRadians
        case .leftHigh:
            fallthrough
        case .leftLow:
            fallthrough
        case .left:
               return -90.degreesToRadians
        default:
               return  0.degreesToRadians
        }
    }

    func setupScoreFor(_ scene: SKNode,player:CardPlayer) -> SKLabelNode
        {
            
            let fontsize : CGFloat = FontSize.smaller.scale
            let l = Label(fontNamed:"Verdana").withShadow()
            
            l.text = ""
            l.fontSize = fontsize
            l.name = player.name
  
  
            let side = player.sideOfTable
   
            l.zPosition = 201
            l.zRotation = ScoreDisplay.scoreRotation(side)

            scene.addChild(l)

            l.rac_text <~ SignalProducer.combineLatest(player.currentTotalScore.producer, player.noOfWins.producer)
                . map {
                    next in
                    let name = player.name
                    
                    let wins = next.1
                    let score = next.0
                    
                    return ScoreDisplay.scoreToString(name,wins,score)
                    
            }

            return l
        }
    
  
public func setupScoreArea(_ scene: SKNode, players: [CardPlayer])
{
    scoreLabel  = []

    self.players=players
    for player in players
    {
        scoreLabel.append(setupScoreFor(scene,player:player))
    }
}

    public func resetScoreLabels(_ players: [CardPlayer], size: CGSize, bannerHeight:CGFloat)
    {
    for (player,score) in zip(players,ScoreDisplay.sharedInstance.scoreLabel)
      {
      score.position = ScoreDisplay.scorePosition(player.sideOfTable, size: size, bannerHeight:bannerHeight )
      score.zRotation = ScoreDisplay.scoreRotation(player.sideOfTable)
      }
    }
}
