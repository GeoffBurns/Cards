//
//  RangeOption.swift
//  
//
//  Created by Geoff Burns on 30/10/19.
//

import SpriteKit



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
 
   
        super.init( defaultValue: defaultValue, key: key){ () in return DisplayedRange(min:min, max:max, current:defaultValue, text: prompt.localize)}
      
    }
     
}


