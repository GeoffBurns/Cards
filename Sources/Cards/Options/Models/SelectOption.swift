//
//  File.swift
//  
//
//  Created by Geoff Burns on 30/10/19.
//

import Foundation


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

        super.init(defaultValue: defaultValue, key: key)  { () in return DisplayedSelection(list: selectStrings, current: defaultValue, text: prompt.localize)}
    }
    
}

