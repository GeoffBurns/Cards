//
//  File.swift
//  
//
//  Created by Geoff Burns on 30/10/19.
//


import SpriteKit


public class DisplayedInfo : DisplayedTextBase<String>, CanDisable {

    fileprivate func showEnabledState() {
        if enabled {
            label.fontColor = .white
        } else {
            let green = UIColor(red: 0.0, green: 0.7, blue: 0.0, alpha: 0.7)

            label.fontColor = green
        }
    }
    
    public var enabled : Bool = true { didSet { showEnabledState() } }

public init(text: String)
{
    super.init("",text:text)
    label.fontSize =  FontSize.smaller.scale
    label.text = text
    self.addChild(label)
    showEnabledState() 
}

public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}
}
