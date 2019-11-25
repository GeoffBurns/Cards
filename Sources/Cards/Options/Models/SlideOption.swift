//
//  SlideOption.swift
//  
//
//  Created by Geoff Burns on 30/10/19.
//

import SpriteKit


public class SlideOption :  SaveableOptionBase<Int>, CanDisable
{
    public var enabled : Bool = true { didSet {
           sliderCtrl.enabled = enabled
           }}
    var sliderCtrl : DisplayedSlider
    public var onValueChanged : (Int) -> Void = { _ in }
    public override var value : Int  {
           get {
                let result = UserDefaults.standard.integer(forKey: key)
                if result == 0 { return defaultValue }
                return result
               }
           set (newValue) {
                UserDefaults.standard.set(newValue, forKey: key)
                onValueChanged(newValue)
        }
        }

    convenience init(min:Int, max:Int, defaultValue:Int, color:UIColor, prompt: String, key: GameProperties)
    {
        self.init(min:min, max:max, defaultValue:defaultValue, color:color, prompt: prompt, key: key.rawValue)
    }
    public init(min:Int, max:Int, defaultValue:Int, color:UIColor, prompt: String, key: String)
    {
        var currentValue = UserDefaults.standard.integer(forKey: key)
        if currentValue == 0 { currentValue = defaultValue }
        self.sliderCtrl = DisplayedSlider(min:min, max:max, current: currentValue,  color:color, text: prompt.localize)
        super.init(displayed: self.sliderCtrl, defaultValue: defaultValue, key: key)
     //   self.sliderCtrl.current = self.value
        self.sliderCtrl.onValueChanged = { [weak self] newValue in
            if let s = self { s.value = newValue }}
    }
    
    
    public override func onRemove() {
         self.sliderCtrl.removeSlider()
    }
    public override func onAdd(_ point :CGPoint) {
        self.sliderCtrl.addSlider(point)
    }
    public override func onAdd(_ point :CGPoint, size:CGSize) {
        self.sliderCtrl.addSlider(point, size:size)
    }
}

