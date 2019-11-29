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
           sliderCtrl?.enabled = enabled
           }}
   // override public var hasChanged: Bool { get { return false }}
    var sliderCtrl : DisplayedSlider? {get{ _displayed as? DisplayedSlider }}
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
     //   var currentValue = UserDefaults.standard.integer(forKey: key)
     //   if currentValue == 0 { currentValue = defaultValue }
  
        super.init(defaultValue: defaultValue, key: key) {
            print("missing factory for slider")
            return DisplayedBase<Int>(0)
            }
        
        self.viewFactory =  { [weak self] in
            let sliderCtrl = DisplayedSlider(min:min, max:max, current: self?.value ?? defaultValue,
                                                 color:color, text: prompt.localize)
                    sliderCtrl.onValueChanged = { [weak self] newValue in
                                                    if let s = self { s.value = newValue }}
                return sliderCtrl
        }
    }
    
    
    public override func onRemove() {
//         let new = self.sliderCtrl?.current
 //        self.value =  new ?? defaultValue
         self.sliderCtrl?.removeSlider()
       
    }
    public override func onAdd(_ point :CGPoint) {
        self.sliderCtrl?.addSlider(point)
        self.sliderCtrl?.current = self.value
    }
    public override func onAdd(_ point :CGPoint, size:CGSize) {
        self.sliderCtrl?.addSlider(point, size:size)
        
        self.sliderCtrl?.current = self.value
    }
}

