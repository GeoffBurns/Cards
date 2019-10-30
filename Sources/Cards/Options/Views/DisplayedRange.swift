//
//  NumberRangeToggle.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 19/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//


import SpriteKit

/// User input control for integers
open class DisplayedRange: DisplayedTextBase<Int> {
    var min = 1
    var max = 10

    
    
    public init(min:Int, max:Int, current:Int, text: String)
    {
    self.min = min
    self.max = max

    super.init(current,text:text)
    self.onPreValueChange = { (newValue:Int) in
                               if(newValue < min) {  return max }
                                if(newValue > max) { return min }
                               return newValue
                   }
    self.onValueChanged = { (_:Int) in self.update()}
     
    label.text = "\(text) : \(current)"
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
    self.isUserInteractionEnabled = true
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func update()
    {
        label.text = "\(text) : \(current)"
    }
    func touchDown()
    {
        current -= 1
        if(current < min)
        {
           current = max
        }
        update()
    }
    func touchUp()
    {
        current += 1
        if(current > max)
        {
            current = min
        }
        update()
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */

        for touch in (touches )
        {
            let touchPoint = touch.location(in: self)
            if let touchedNode : SKSpriteNode = self.atPoint(touchPoint) as? SKSpriteNode, touchedNode.name == "down"
            {
                touchDown()
                return
            }
            
            if label.contains(touchPoint) {
    
            touchUp()
            return
        }
    }

    }}

