//
//  SliderCtrl.swift
//  
//
//  Created by Geoff Burns on 29/10/19.
//

import SpriteKit


/// User input control for float
open class SliderCtrl: DisplayedTextBase<Int> {
    var min = 1
    var max = 101
    var color : UIColor = .white
    public override var current : Int {
        get { return Int(slider.value) }
        set(newValue) { slider.value = Float(newValue) }
    }
    let slider = UISlider()
 //   public var onValueChanged : (Int) -> Void = { _ in }
    public func removeSlider() {
        slider.removeFromSuperview()
        
    }
        
    public func addSlider(_ point :CGPoint) {
        let height = label.frame.size.height
        let width = label.frame.size.width
        
        
        if let scene = self.label.scene
        {
          //  let center1 =  scene.convertPoint(toView: CGPoint(x: 05*width, y: 0))
       
          //  let center = scene.convert(CGPoint(x: 0.5*width, y: 0), from: label)// label.convertPoint((fromView: CGPoint(x: 05*width, y: 0)))
           // label.convert(CGPoint(x: 05*width, y: 0), to: scene)
            
            let page_height = scene.frame.height
            slider.frame = CGRect(x: point.x - 10.0*height ,
                                  y: page_height - point.y + 0.6*height  ,
                                  width: 20.0*height,
                                  height: 0.6*height)
          //  let frame1 = scene.frame
          //   let frame2 = label.frame
            ///slider.center = self.view.center
           
            slider.minimumTrackTintColor = .lightGray
            slider.maximumTrackTintColor = .lightGray
            slider.thumbTintColor = color
          
            slider.maximumValue = Float(max)
            slider.minimumValue = Float(min)
          
            //slider.addTarget(self, action: #selector(ViewController.changeVlaue(_:)), for: .valueChanged)
            //  self.scene?.view?.addSubview(slider)
            if let view = scene.view
            {
                view.addSubview(slider)
            }
            slider.value = Float(_current)
            slider.addTarget(self, action: #selector(SliderCtrl.sliderValueDidChange(_:)), for: .valueChanged)

        }
    }
    @objc func sliderValueDidChange(_ sender:UISlider!)
    {
        onValueChanged(Int(sender!.value))
    }

    public init(min:Int, max:Int, current: Int, color:UIColor, text: String, onChange: @escaping (Int)->Void)
    {
        self.min = min
        self.max = max
        self.color = color
        super.init(current,text:text, onChange: onChange)
        updateLabelText()
        self.addChild(label)
   
    }
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
    
}
    
