//
//  SaveableOption.swift
//  Cards
//
//  Created by Geoff Burns on 22/7/18.
//  Copyright © 2018 Geoff Burns. All rights reserved.
//

import SpriteKit

protocol DisplayedItem : class
{
    associatedtype Value
    var current : Value {get set}
}


public protocol SaveableOption
{
    var view : SKNode {get}
    var hasChanged : Bool {get}
    func load()
    func save()
}
extension Sequence where Iterator.Element == SaveableOption
{
    var hasAnyChanged : Bool { get {
        for o in self
        {
            if o.hasChanged { return true }
        }
        return false
        }}
    
    func saveAll()
    {
        for o in self
        {
            o.save()
        }
    }
    func loadAll()
    {
        for o in self
        {
            o.load()
        }
    }
}
extension Sequence where Iterator.Element == SKNode
{
    public func removeAllFromParent()
    {
        for o in self
        {
            if o.parent != nil {
                o.removeFromParent()
            }
        }
    }
}

public class RangeOption : SaveableOption
{
    public var view: SKNode { get { return toggle as SKNode}}
    
    public var hasChanged: Bool { get { return toggle.current == value }}
    
    var toggle : NumberRangeToggle
    var defaultValue : Int
    var key : String
    public var value : Int  {
           get {
                let result = UserDefaults.standard.integer(forKey: key)
                    if result == 0
                        {
                                return defaultValue
                        }
                return result
               }
           set (newValue) {
                UserDefaults.standard.set(newValue, forKey: key)
               }
        }

    convenience init(min:Int, max:Int, defaultValue:Int, prompt: String, key: GameProperties)
    {
        self.init(min:min, max:max, defaultValue:defaultValue, prompt: prompt, key: key.rawValue)
    }
    public init(min:Int, max:Int, defaultValue:Int, prompt: String, key: String)
    {
        self.key = key
        self.defaultValue = defaultValue
        self.toggle = NumberRangeToggle(min:min, max:max, current:defaultValue, text: prompt.localize)
        load()
    }
     
    public func load() {
        toggle.current = value
    }
    
    public func save() {
        value = toggle.current
    }
}



public class YesNoOption : SaveableOption
{
    public var view: SKNode { get { return toggle as SKNode}}
    
    public var hasChanged: Bool { get { return (toggle.current == value) != isInverted }}
    
    var toggle : BinaryToggle
    var isInverted : Bool
    var key : String
    public var value : Bool  {
        get { return UserDefaults.standard.bool(forKey: key) != isInverted }
        set (newValue) {
            UserDefaults.standard.set(newValue != isInverted, forKey: key)
        }
    }
    
    convenience init(inverted:Bool, prompt: String, key: GameProperties)
    {
        self.init(inverted:inverted, prompt: prompt, key: key.rawValue)
    }
    public init(inverted:Bool, prompt: String, key: String)
    {
        self.key = key
        self.isInverted = inverted
        self.toggle = BinaryToggle(current: isInverted, text: prompt.localize)
        load()
    }
    
    public func load() {
        toggle.current = value
    }
    
    public func save() {
        value = toggle.current
    }
}
public class InfoOption : SaveableOption
{
    public var view: SKNode { get { return info.label as SKNode}}
    
    public var hasChanged: Bool = false
    
    var info : InfoLabel
    
    public init(prompt: String)
    {
        self.info = InfoLabel(text: prompt.localize)
    }
    
    public func load() {
    }
    
    public func save() {
    }
}

public class SelectOption : SaveableOption
{
    public var view: SKNode { get { return toggle as SKNode}}
    public var hasChanged: Bool { get { return toggle.current == value }}
    var toggle : ListToggle
    var defaultValue : Int
    var key : String
    public var valueWasSetTo : (Int) -> Void = { _ in }
    public var value : Int  {
        get {
            let result = UserDefaults.standard.integer(forKey: key)
            if result == 0
            {
                return defaultValue
            }
            return result
        }
        set (newValue) {
            UserDefaults.standard.set(newValue, forKey: key)
            valueWasSetTo(newValue)
        }
    }
    
    convenience init(selections:[String], defaultValue:Int, prompt: String, key: GameProperties)
    {
        self.init(selections:selections, defaultValue:defaultValue, prompt: prompt, key: key.rawValue)
    }
    public init(selections:[String], defaultValue:Int, prompt: String, key: String)
    {
        self.key = key
        self.defaultValue = defaultValue
        let selectStrings = selections.map { $0.isNumber ? $0 : $0.localize }
        self.toggle = ListToggle(list: selectStrings, current: defaultValue, text: prompt.localize)
        load()
    }
    
    public func load() {
        toggle.current = value
    }
    
    public func save() {
        value = toggle.current
    }
}
