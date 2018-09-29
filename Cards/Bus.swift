//
//  Bus.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 7/10/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//


import ReactiveSwift
import enum Result.NoError


public class Bus {
    
    public let (gameSignal,gameSink) = Signal<GameEvent,Result.NoError>.pipe()
    
    public let (noteSignal,noteSink) = Signal<GameNotice,Result.NoError>.pipe()
    
    public static let sharedInstance = Bus()
    fileprivate init() { }
    
    public static func send(_ gameEvent:GameEvent)
    {
        sharedInstance.gameSink.send( value: gameEvent)
    }
    public static func send(_ gameNotice:GameNotice)
    {
        sharedInstance.noteSink.send( value: gameNotice)
    }
    
    public func send(_ gameEvent:GameEvent)
    {
    gameSink.send( value: gameEvent)
    }
    public func send(_ gameNotice:GameNotice)
    {
        noteSink.send( value: gameNotice)
    }
}
