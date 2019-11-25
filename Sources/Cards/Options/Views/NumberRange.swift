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
    self.onValueChanged = { [weak self] (_:Int) in self?.updateLabelText()}
        
         
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
