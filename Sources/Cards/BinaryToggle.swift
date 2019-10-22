//
//  BinaryToggle.swift
//  Cards
//
//  Created by Geoff Burns on 26/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

/// User input control for integers
public class BinaryToggle: SKNode {
    
    
    public var current : Bool {didSet {updateLabelText()}}
    public var text:String {didSet {updateLabelText()}}
    
    public var label = SKLabelNode(fontNamed:"Chalkduster")
    public var YorN : String { return current ? "Yes".localize : "No".localize }
    
    
    public init(current:Bool, text: String)
    {
        self.current = current
        label.fontSize =  FontSize.big.scale
        self.text = text
        label.isUserInteractionEnabled = false
        
        super.init()
        updateLabelText()
        self.addChild(label)
        self.isUserInteractionEnabled = true
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateLabelText()
    {
        label.text = "\(text) : \(self.YorN)"
    }
    func touched()
    {
        current  = !current
        updateLabelText()
    }
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in (touches )
        {
            let touchPoint = touch.location(in: self)
            
            if label.contains(touchPoint) {
                
                touched()
                return
            }
        }
        
    }}


/// Info
public class InfoLabel  {

    
    public var label = SKLabelNode(fontNamed:"Chalkduster")
    
    
    public init(text: String)
    {
        label.fontSize =  FontSize.smaller.scale
        label.text = text
    //    label.isUserInteractionEnabled = false

      //  super.init()
      //  self.addChild(label)
        label.isUserInteractionEnabled = true
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


    }
