//
//  InfoOption.swift
//  
//
//  Created by Geoff Burns on 30/10/19.
//

import SpriteKit



public class InfoOption :  SaveableOptionBase<String>, CanDisable
{
    open override var hasChanged: Bool { get {return false}}
    public override var value : String  {
        get { return "" }
        set (newValue) { }
    }
    public var enabled : Bool = true { didSet {
              info?.enabled = enabled
              }}
    var info : DisplayedInfo? = nil
    public init(prompt: String)
    {
        super.init(defaultValue: "", key: "") {
                   print("missing factory for info")
                   return DisplayedBase<String>("")
                   }
               
         self.viewFactory =  { [weak self] in
                      
                                  let i = DisplayedInfo(text: prompt.localize)
                                  self?.info = i
                                  return i
               }
    }
    
}

