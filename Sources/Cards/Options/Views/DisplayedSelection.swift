//
//  ListOption.swift
//  
//
//  Created by Geoff Burns on 30/10/19.
//


import SpriteKit

/// User input control for integers
open class DisplayedSelection:  DisplayedTextBase<Int> {
    var list = [String]()
 //   var text:String {didSet {update()}}
    
 //   var label = SKLabelNode(fontNamed:"Chalkduster")
    var index : Int {
        var result = current - 1
        if result < 0 { result = 0 }
        if result > list.count - 1 { result = list.count - 1 }
        return result
    }
    
    public init(list:[String], current: Int, text: String)
    {
        self.list = list
 ///       label.fontSize = FontSize.big.scale
  //      self.text = text
   //     label.isUserInteractionEnabled = false
        super.init(current,text:text)
        self.onPreValueChange = { (newValue:Int) in
                             if(newValue < 0) {  return list.count }
                              if(newValue > list.count) { return 1 }
                             return newValue
                 }
        self.onValueChanged = { [weak self] (_:Int) in self?.update()}
         
        label.text = "\(text) : \(list[index])"
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
        label.text = "\(text) : \(list[index])"
    }
    func touchDown()
    {
        current -= 1
        if(current < 0)
        {
            current = list.count
        }
        update()
    }
    func touchUp()
    {
        current += 1
        if(current > list.count)
        {
            current = 1
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

/// User input control for integers
/*
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

*/
