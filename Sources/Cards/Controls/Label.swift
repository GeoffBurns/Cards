//
//  Label.swift
//  Cards
//
//  Created by Geoff Burns on 25/10/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//
import SpriteKit


typealias TextChangeHandler = (String?) -> Void
typealias FontSizeChangeHandler = (CGFloat) -> Void

public class Label : SKLabelNode
{
    override public var text : String? { didSet { for textChangeHandler in textChangeHandlers { textChangeHandler(text)}}}
    override public var fontSize : CGFloat { didSet { for fontSizeChangeHandler in fontSizeChangeHandlers { fontSizeChangeHandler(fontSize)}}}

    var textChangeHandlers = [TextChangeHandler]()
    var fontSizeChangeHandlers = [FontSizeChangeHandler]()
    var afterDisplayAction:()->() = {}
    var innerNode : SKLabelNode? = nil
    public var displayTime : TimeInterval = 6
    public func withShadow() -> Label
    {
        if innerNode != nil
        {
            return self
        }
        innerNode = SKLabelNode(fontNamed: self.fontName)

        self.fontColor = UIColor(red: 0.0, green: 0.2, blue: 0.0, alpha: 0.7)
        innerNode!.position = CGPoint(x:-2,y:2)
        innerNode!.fontColor = UIColor.white
        innerNode!.zPosition = 10
        addChild(innerNode!)
        
        textChangeHandlers.append({self.innerNode!.text = $0})
        fontSizeChangeHandlers.append({self.innerNode!.fontSize = $0})
        
        return self   
    }
    public func withFadeOutAndAction(_ action:@escaping ()->()) -> Label
    {
        
        afterDisplayAction = action
        textChangeHandlers.append(startfadeOutThenAction)
        
        return self
    }
    public func withFadeOut() -> Label
    {
        textChangeHandlers.append(startfadeOut)
        
        return self
    }
    public func withFadeInOut() -> Label
    {
        textChangeHandlers.append(startfadeInOut)
        
        return self
    }
    public func startfadeOut(_ text: String?)
        {
          removeAction(forKey: "Fade")
        
        alpha = 1.0
        if let t = text, t != ""{
        run(SKAction.fadeOut(withDuration: displayTime), withKey:"Fade")
        }
    }
    public func startfadeOutThenAction(_ text: String?)
    {
        removeAction(forKey: "Fade")
        
        alpha = 1.0
        if let t = text, t != ""
        {
            let action = SKAction.sequence([
                    SKAction.fadeOut(withDuration: displayTime),
                     SKAction.run(afterDisplayAction) 
                ])
            
            run(action, withKey:"Fade")
        }
    }
    public func startfadeInOut(_ text: String?)
    {
         removeAction(forKey: "Fade")
        
        alpha = 1.0
        if let t = text, t != ""
        {
            let action = SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.fadeOut(withDuration: displayTime),
                    SKAction.wait(forDuration: displayTime),
                    SKAction.fadeIn(withDuration: displayTime),
                    SKAction.wait(forDuration: displayTime),
                    ] )
            )
            run(action, withKey:"Fade")
        }
    }
    
    public func resetToScene(_ scene:SKNode)
    {
        if parent != nil
        {
            removeFromParent()
        }
        text = ""
        scene.addChild(self)
    }
}
