//
//  BinaryToggle.swift
//  Cards
//
//  Created by Geoff Burns on 26/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

public class Touchable<DisplayedValue> : DisplayedTextBase<DisplayedValue>
{


    public override init(_ current : DisplayedValue, text: String )
    {
        
        super.init(current, text: text )
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func isTouching(_ touches: Set<UITouch>) -> Bool {

    //    guard let parent = parent else {
    //        return false
     //   }

      //  let frame = self.calculateAccumulatedFrame()

      
        for touch in touches {

            let coordinate = touch.location(in: self)

            if label.contains(coordinate) {
                return true
            }
        }

        return false
    }
   
}


public class TouchableToggle : Touchable<Bool>
{


    public override init(_ current : Bool, text: String )
       {
           
           super.init(current, text: text )
       }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func touched()
     {
        current  = !(current)
    
     }
     public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         /* Called when a touch begins */
         
       
             if isTouching(touches) {
                 
                 touched()
                 return
             }
  
     }
}


/// User input control for integers
public class BinaryToggle:  TouchableToggle {
    
    public var YorN : String { return current ? "Yes".localize : "No".localize }
   
    public init(current:Bool, text: String)
    {
        super.init(current,text:text)
        self.onValueChanged = { (_:Bool) in self.updateLabelText()}
    
        updateLabelText()
        self.addChild(label)
        self.isUserInteractionEnabled = true
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   public override func updateLabelText()
    {
        label.text = "\(text) : \(self.YorN)"
    }
 
}

/// Info
public class InfoLabel : DisplayedTextBase<String> {

    public init(text: String)
    {
        super.init("",text:text)
        label.fontSize =  FontSize.smaller.scale
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    }
