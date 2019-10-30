//
//  Touchable.swift
//  
//
//  Created by Geoff Burns on 30/10/19.
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



public class TouchableRange : Touchable<Int>
{

/*
    public override init(_ current : Int, text: String )
       {
           
           super.init(current, text: text )
       }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    */

     func touchDown()
      {
        current -= 1

       
      }
      func touchUp()
      {
        current += 1
    
      }
      
      open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          /* Called when a touch begins */

          for touch in (touches )
          {
              let touchPoint = touch.location(in: self)
              if let touchedNode : SKSpriteNode = self.atPoint(touchPoint) as? SKSpriteNode {
              if touchedNode.name == "down"
              {
                  touchDown()
                  return
              }
              
           if touchedNode.name == "label" || touchedNode.name == "up"
            {
      
              touchUp()
              return
            }
          }
        }
    }

}


