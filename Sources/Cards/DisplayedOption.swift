//
//  File.swift
//  
//
//  Created by Geoff Burns on 30/10/19.
//

import SpriteKit

protocol DisplayedItem : class
{
    associatedtype Value
    var current : Value {get set}
}


open class DisplayedBase<DisplayedValue> : SKNode, DisplayedItem
{
    public var _current : DisplayedValue
    public var current : DisplayedValue {
        get {return _current }
        set(newValue) {
            _current = onPreValueChange(newValue)
            onValueChanged(_current)
        }
        
    }
    public var onValueChanged  =  {(_:DisplayedValue) in return }
    
    public var onPreValueChange  =  {(newValue:DisplayedValue) in return newValue }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(_ current : DisplayedValue)
    {
        self._current = current
        super.init()
    }
    public init(_ current : DisplayedValue, onChange : @escaping (DisplayedValue)->Void)
    {
        self._current = current
        self.onValueChanged = onChange
        super.init()
    }
}

open class DisplayedTextBase<DisplayedValue> : DisplayedBase<DisplayedValue>
{
    public var text:String {didSet {updateLabelText()}}
    public var label = SKLabelNode(fontNamed:"Chalkduster")
    

    public init(_ current : DisplayedValue, text: String )
    {
        self.text = text
        label.fontSize =  FontSize.big.scale
        label.isUserInteractionEnabled = false
        super.init(current)
    }
    public init(_ current : DisplayedValue, text: String, onChange : @escaping (DisplayedValue)->Void)
    {
     self.text = text
             label.fontSize =  FontSize.big.scale
             label.isUserInteractionEnabled = false
        super.init(current,onChange:onChange)
    }
    public required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     

    public func updateLabelText()
      {
          label.text = text
      }
}
