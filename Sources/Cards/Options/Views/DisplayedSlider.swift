//
//  SliderCtrl.swift
//  
//
//  Created by Geoff Burns on 29/10/19.
//

import SpriteKit

public protocol CanDisable {
    var enabled : Bool { get set }
}

/// User input control for float
open class DisplayedSlider: DisplayedTextBase<Int>, CanDisable {
    var min = 1
    var max = 101
    var color : UIColor = .white
    public var enabled : Bool = true { didSet { showEnabledState() } }
    
    public override var current : Int {
        get { return Int(slider.value) }
        set(newValue) { slider.value = Float(newValue) }
    }
    let slider = UISlider()

  /*  public init(min:Int, max:Int, current: Int, color:UIColor, text: String, onChange: @escaping (Int)->Void)
    {
        self.min = min
        self.max = max
        self.color = color
        super.init(current,text:text, onChange: onChange)
        updateLabelText()
        self.addChild(label)
   
    }*/
    public init(min:Int, max:Int, current: Int, color:UIColor, text: String)
      {
          self.min = min
          self.max = max
          self.color = color
          super.init(current,text:text)
          updateLabelText()
          self.addChild(label)
     
      }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func updateLabelText()
    {
        label.text = self.text
        slider.setValue(Float(current), animated: false)
    }
    
    fileprivate func showEnabledState() {
        if enabled {
            slider.minimumTrackTintColor = .lightGray
            slider.maximumTrackTintColor = .lightGray
            slider.thumbTintColor = color
            slider.isUserInteractionEnabled = true
            label.fontColor = .white
        } else {
            let green = UIColor(red: 0.0, green: 0.7, blue: 0.0, alpha: 0.7)
            slider.minimumTrackTintColor = green
            slider.maximumTrackTintColor = green
            slider.thumbTintColor = green
            slider.isUserInteractionEnabled = true
            label.fontColor = green
        }
    }
    
    public func addSlider(_ point :CGPoint, size:CGSize) {
         let height = label.frame.size.height
        // let width = label.frame.size.width
         
         
         if let scene = self.label.scene
         {
             let page_height = size.height
             slider.frame = CGRect(x: point.x - 10.0*height ,
                                   y: page_height - point.y + 0.6*height  ,
                                   width: 20.0*height,
                                   height: 0.6*height)

             slider.maximumValue = Float(max)
             slider.minimumValue = Float(min)
           
        
             if let view = scene.view
             {
                 view.addSubview(slider)
             }
             slider.value = Float(_current)
             slider.addTarget(self, action: #selector(DisplayedSlider.sliderValueDidChange(_:)), for: .valueChanged)
             showEnabledState()
         }
     }
    public func addSlider(_ point :CGPoint) {
           let height = label.frame.size.height
         //  let width = label.frame.size.width
           
           
           if let scene = self.label.scene
           {
               let page_height = scene.frame.height
               slider.frame = CGRect(x: point.x - 10.0*height ,
                                     y: page_height - point.y + 0.6*height  ,
                                     width: 20.0*height,
                                     height: 0.6*height)

               slider.maximumValue = Float(max)
               slider.minimumValue = Float(min)
             
          
               if let view = scene.view
               {
                   view.addSubview(slider)
               }
               slider.value = Float(_current)
               slider.addTarget(self, action: #selector(DisplayedSlider.sliderValueDidChange(_:)), for: .valueChanged)
               showEnabledState()
           }
       }
      
  
       
    public func removeSlider() {
        slider.removeFromSuperview()
        
    }
        
     @objc func sliderValueDidChange(_ sender:UISlider!)
     {
        if self.enabled { onValueChanged(Int(sender!.value)) }
        else { slider.value = Float(_current) }
     }
}
    
