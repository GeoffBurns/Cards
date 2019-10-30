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


public class RangeOption :  SaveableOptionBase<Int>
{

    public override var value : Int  {
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
 
        let numberRange = NumberRangeToggle(min:min, max:max, current:defaultValue, text: prompt.localize)

        super.init(displayed: numberRange, defaultValue: defaultValue, key: key)
      
    }
     
}



public class YesNoOption : SaveableOptionBase<Bool>
{
 
    open override var hasChanged: Bool { get { return (displayed.current == value) != isInverted }}
    
    
    public var onValueChanged : (Bool) -> Void = { _ in }
    var isInverted : Bool
    public override var value : Bool  {
        get { return UserDefaults.standard.bool(forKey: key) != isInverted }
        set (newValue) {
            UserDefaults.standard.set(newValue != isInverted, forKey: key)
            onValueChanged(newValue)
        }
    }
    convenience init(inverted:Bool, prompt: String, key: GameProperties)
    {
        self.init(inverted:inverted, prompt: prompt, key: key.rawValue,  isImmediate: false)
    }
    convenience init(inverted:Bool, prompt: String, key: GameProperties, isImmediate: Bool)
    {
        self.init(inverted:inverted, prompt: prompt, key: key.rawValue,  isImmediate: isImmediate)
    }
    public init(inverted:Bool, prompt: String, key: String, isImmediate: Bool)
    {
        self.isInverted = inverted
        let displayed = BinaryToggle(current: isInverted, text: prompt.localize)
        super.init(displayed: displayed, defaultValue: inverted, key: key)
        if isImmediate {
            let oldOnChange = displayed.onValueChanged
            displayed.onValueChanged = { newValue in
                self.value =  newValue
                oldOnChange(newValue)
            }
        }
        
        
    }
    
}

public class SlideOption :  SaveableOptionBase<Int>
{

    var sliderCtrl : SliderCtrl
    public var onValueChanged : (Int) -> Void = { _ in }
    public override var value : Int  {
           get {
                let result = UserDefaults.standard.integer(forKey: key)
                if result == 0 { return defaultValue }
                return result
               }
           set (newValue) {
                UserDefaults.standard.set(newValue, forKey: key)
                onValueChanged(newValue)
        }
        }

    convenience init(min:Int, max:Int, defaultValue:Int, color:UIColor, prompt: String, key: GameProperties)
    {
        self.init(min:min, max:max, defaultValue:defaultValue, color:color, prompt: prompt, key: key.rawValue)
    }
    public init(min:Int, max:Int, defaultValue:Int, color:UIColor, prompt: String, key: String)
    {
        var currentValue = UserDefaults.standard.integer(forKey: key)
        if currentValue == 0 { currentValue = defaultValue }
        self.sliderCtrl = SliderCtrl(min:min, max:max, current: currentValue,  color:color, text: prompt.localize)
        super.init(displayed: self.sliderCtrl, defaultValue: defaultValue, key: key)
     //   self.sliderCtrl.current = self.value
        self.sliderCtrl.onValueChanged = { newValue in self.value = newValue}
    }
    
    
    public override func onRemove() {
         self.sliderCtrl.removeSlider()
    }
    public override func onAdd(_ point :CGPoint) {
        self.sliderCtrl.addSlider(point)
    }
}

public class InfoOption :  SaveableOptionBase<String>
{
    
    open override var hasChanged: Bool { get {return false}}
    
    
    public init(prompt: String)
    {
        let info = InfoLabel(text: prompt.localize)
        super.init(displayed: info, defaultValue: "", key: "")
    }
    
}

public class SelectOption : SaveableOptionBase<Int>
{
  

    public var onValueChanged : (Int) -> Void = { _ in }
    public override var value : Int  {
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
            onValueChanged(newValue)
        }
    }
    
    convenience init(selections:[String], defaultValue:Int, prompt: String, key: GameProperties)
    {
        self.init(selections:selections, defaultValue:defaultValue, prompt: prompt, key: key.rawValue)
    }
    public init(selections:[String], defaultValue:Int, prompt: String, key: String)
    {
        let selectStrings = selections.map { $0.isNumber ? $0 : $0.localize }
        let displayed = ListToggle(list: selectStrings, current: defaultValue, text: prompt.localize)
        super.init(displayed: displayed, defaultValue: defaultValue, key: key)
    }
    
}

