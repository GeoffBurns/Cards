//
//  NumberRange.swift
//  
//
//  Created by Geoff Burns on 26/10/19.
//

import SpriteKit

/// User input control for integers
public class NumberRange:  TouchableRange {
    var min = 1
    var max = 10
    

    public init(min:Int, max:Int, current:Int, text: String)
    {
    self.min = min
    self.max = max
    super.init(current,text:text)
    label.isUserInteractionEnabled = false
    self.onPreValueChange = { (newValue:Int) in
                           if(newValue < min) {  return max }
                            if(newValue > max) { return min }
                           return newValue
               }
    self.onValueChanged = { (_:Int) in self.updateLabelText()}
        
         
    let height = label.frame.size.height
    let width = label.frame.size.width
    /*    let bundle = Bundle(for: NumberRangeToggle.self)
       let bundle = Bundle(identifier: "com.GeoffBurns.Cards")
        let image = UIImage(named: "triangle", in: bundle, compatibleWith: nil)
        let Texture = SKTexture(image: image!)
        let up = SKSpriteNode(texture:Texture) */
    let up =   SKSpriteNode(imageNamed:"triangle")
    up.xScale = 0.25
    up.yScale = 0.10
  //  up.anchorPoint = CGPoint(x: 1.0, y: 0.0)
    up.position = CGPoint(x:width,y:height*1.67)
  //  up.position = CGPoint(x:width,y:height*0.67)
    
    let down =   SKSpriteNode(imageNamed:"triangle")
    down.name = "down"
    down.xScale = 0.25
        
    /// This works on simulator but not on device
    /*
    down.yScale = -0.15
    down.anchorPoint = CGPoint(x: 1.0, y: 1.0)
    */
    /// This works on simulator AND on device
    down.yScale = 0.10
   // down.anchorPoint = CGPoint(x: 0.0, y: 1.0)
    down.zRotation = 180.degreesToRadians

    down.position = CGPoint(x:width,y:-height*1.6)
    label.addChild(up)
    label.addChild(down)
    label.name = "label"
    self.addChild(label)
//    down.position = CGPoint(x:width,y:-height*1.6)

    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func updateLabelText() {
       label.text = "\(text) : \(current)"
    }

}

/// User input control for integers
public class ListToggle2:  TouchableRange {
    var list = [String]()


    var index : Int {
        var result = current - 1
        if result < 0 { result = 0 }
        if result > list.count - 1 { result = list.count - 1 }
        return result
    }

    
    public init(list:[String], current: Int, text: String)
    {
        self.list = list
        super.init(current, text:text)

        self.onPreValueChange = { (newValue:Int) in
                    if(newValue < 0) {  return list.count }
                     if(newValue > list.count) { return 1 }
                    return newValue
        }
        self.onValueChanged = { (_:Int) in self.updateLabelText()}

        let height = label.frame.size.height
        let width = label.frame.size.width
        let up =   SKSpriteNode(imageNamed:"triangle")
        up.xScale = 0.30
        up.yScale = 0.11
        up.anchorPoint = CGPoint(x: 1.0, y: 0.0)
        up.position = CGPoint(x:width*0.5,y:height*0.62)
        label.addChild(up)
        
        let down =   SKSpriteNode(imageNamed:"triangle")
        down.name = "down"
        down.xScale = 0.30
        
        /// This works on simulator but not on device
        /*
        down.yScale = -0.15
        down.anchorPoint = CGPoint(x: 1.0, y: 1.0)
        */
        /// This works on simulator AND on device
        down.yScale = 0.11
        down.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        down.zRotation = 180.degreesToRadians
        ////
        
        down.position = CGPoint(x:width*0.5,y:-height*0.57)
        label.addChild(down)
        self.addChild(label)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func updateLabelText()
    {
        label.text = "\(text) : \(list[index])"
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

