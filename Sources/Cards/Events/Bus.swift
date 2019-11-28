//
//  Bus.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 7/10/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//


import RxRelay
//import enum Result.NoError


public class Bus {
    
    public let events = PublishRelay<GameEvent>()
    
    public let notices = PublishRelay<GameNotice>()
    
    public static let sharedInstance = Bus()
    fileprivate init() { }
    
    public static func send(_ gameEvent:GameEvent)
    {
        sharedInstance.events.accept(gameEvent)
    }
    public static func send(_ gameNotice:GameNotice)
    {
        sharedInstance.notices.accept(gameNotice)
    }
    
    public func send(_ gameEvent:GameEvent)
    {
        self.events.accept(gameEvent)
    }
    public func send(_ gameNotice:GameNotice)
    {
        self.notices.accept(gameNotice)
    }
}
