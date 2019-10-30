//
//  BinaryToggle.swift
//  Cards
//
//  Created by Geoff Burns on 26/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

/// User input control for integers
public class DisplayedYesNo:  TouchableToggle {
    
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


