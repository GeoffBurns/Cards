//
//  SaveableOption.swift
//  Cards
//
//  Created by Geoff Burns on 22/7/18.
//  Copyright © 2018 Geoff Burns. All rights reserved.
//

import SpriteKit


public protocol SaveableOption
{
    var view : SKNode {get}
    var hasChanged : Bool {get}
    func onRemove()
    func onAdd(_ point :CGPoint)
    func onAdd(_ point :CGPoint, size: CGSize)
    func load()
    func save()
}
extension SaveableOption
{
    fileprivate func add(_ i: Int,
                         _ prefix: String,
                         x: CGFloat, y: CGFloat,
                         toPage page: Popup) {
        
        let optionSetting = self.view
       
        optionSetting.name = prefix + (i + 1).description
        let position =  CGPoint(x:x,y:y)
        optionSetting.position = position
        page.addChild(optionSetting)
        onAdd(position)
    }
 fileprivate func add(_ i: Int,
                       _ prefix: String,
                       x: CGFloat, y: CGFloat,
                       size: CGSize,
                       toPage page: Popup) {
      
      let optionSetting = self.view
     
      optionSetting.name = prefix + (i + 1).description
      let position =  CGPoint(x:x,y:y)
      optionSetting.position = position
      page.addChild(optionSetting)
      onAdd(position,size: size)
  }
    
}
public class SaveableOptionBase<OptionType> : SaveableOption where OptionType : Equatable
{
    typealias Value = OptionType
    open var view : SKNode { get { return displayed as SKNode}}
    var displayed : DisplayedBase<OptionType>
    public var value : OptionType
    public var hasChanged: Bool { get { return displayed.current == value }}
    var defaultValue : OptionType
    var key : String
    public init(displayed : DisplayedBase<OptionType>, defaultValue:OptionType, key: String) {
        self.displayed = displayed
        self.value = defaultValue
        self.defaultValue = defaultValue
        self.key = key
        load()
    }
    public func onRemove() {}
    public func onAdd(_ point :CGPoint) {}
    public func onAdd(_ point :CGPoint, size : CGSize) {}
    
    public func load() {
        displayed.current = value
    }
    
    public func save() {
        value = displayed.current
    }
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
    public func removeAllFromParent()
    {
        for o in self
        {
           let view = o.view
            if view.parent != nil {
                o.onRemove()
                view.removeFromParent()
            }
        }
    }
    public func addAll(_ prefix: String,
                       startHeight : CGFloat,
                       separationOfItems : CGFloat,
                       toPage page: Popup) {
             
            let scene = page.gameScene!
            let x = scene.frame.midX
            for (i, optionSetting) in self.enumerated() {
                let y = scene.frame.height * (startHeight - separationOfItems * CGFloat(i))
                optionSetting.add(  i,  prefix, x:x, y:y, toPage: page)
            }
    }
      public func addAll(_ prefix: String,
                         startHeight : CGFloat,
                         separationOfItems : CGFloat,
                         toPage page: Popup,
                         size: CGSize) {
               
     
             let x = size.width*0.5
              for (i, optionSetting) in self.enumerated() {
                let y = size.height * (startHeight - separationOfItems * CGFloat(i))
                optionSetting.add(  i,  prefix, x:x, y:y, size:size, toPage: page)
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

