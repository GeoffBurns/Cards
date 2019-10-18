//
//  Seater.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 23/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//
import SpriteKit


// Where are the players seated
public class Seater
{
    static let seatsFor3 = [SideOfTable.bottom, SideOfTable.right, SideOfTable.left]
    static let seatsFor4 = [SideOfTable.bottom, SideOfTable.right, SideOfTable.top, SideOfTable.left]
    static let seatsFor5 = [SideOfTable.bottom, SideOfTable.right, SideOfTable.topMidRight, SideOfTable.topMidLeft,
        SideOfTable.left]
    static let seatsFor5p = [SideOfTable.bottom,  SideOfTable.rightLow, SideOfTable.rightHigh,  SideOfTable.top,
        SideOfTable.left]
    static let seatsFor6 = [SideOfTable.bottom, SideOfTable.right, SideOfTable.topMidRight, SideOfTable.top, SideOfTable.topMidLeft,
        SideOfTable.left]
    static let seatsFor6p = [SideOfTable.bottom, SideOfTable.rightLow, SideOfTable.rightHigh, SideOfTable.top,SideOfTable.leftHigh, SideOfTable.leftLow]
    static let seatsFor7 = [SideOfTable.bottom, SideOfTable.rightLow, SideOfTable.rightHigh, SideOfTable.topMidRight, SideOfTable.topMidLeft,SideOfTable.leftHigh, SideOfTable.leftLow]
    
    public static func seatsFor(_ noOfPlayers:Int) -> [SideOfTable]
    {
        switch noOfPlayers
        {
        case 3 : return seatsFor3
        case 4 : return seatsFor4
        case 5 : return seatsFor5
        case 6 : return seatsFor6
        case 7 : return seatsFor7
        default : return []
        }
    }
    public static func portraitSeatsFor(_ noOfPlayers:Int) -> [SideOfTable]
    {
        switch noOfPlayers
        {
        case 3 : return seatsFor3
        case 4 : return seatsFor4
        case 5 : return seatsFor5p
        case 6 : return seatsFor6p
        case 7 : return seatsFor7
        default : return []
        }
    }
    
    public static func seatPlayers(_ scene:CardScene, isPortrait:Bool, players:[CardPlayer])
    {
        
        let seats = isPortrait ? Seater.portraitSeatsFor(players.count) : Seater.seatsFor(players.count)
        
        for (i,(player,seat)) in zip(players,seats).enumerated()
        {
            player.setupCardPlayer(scene, playerNo: i)
            player.seatCardPlayer(scene, sideOfTable: seat, isPortrait: isPortrait)
            
        }
    }
    
    public static func reseatPlayers(_ scene:CardScene, isPortrait:Bool, players:[CardPlayer], rotate:Int)
    {
        let s = isPortrait ? Seater.portraitSeatsFor(players.count) : Seater.seatsFor(players.count)
        let seats = s.rotate(rotate)
        
        for (player,seat) in zip(players,seats)
        {
            player.seatCardPlayer(scene, sideOfTable: seat, isPortrait: isPortrait)
        }
    }

}
