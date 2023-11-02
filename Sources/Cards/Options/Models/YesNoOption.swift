//
//  YesNoOption.swift
//  
//
//  Created by Geoff Burns on 30/10/19.
//

import SpriteKit

public class YesNoOption : SaveableOptionBase<Bool>
{
    open override var hasChanged: Bool { get { return (displayed.current == value) != isInverted }}
    
    public var dependencies : [CanDisable] = [] {didSet{ showEnabledStateOfDependencies(self.value) }}
    public var onValueChanged : (Bool) -> Void = { _ in }
    var isInverted : Bool

    public override var value : Bool  {
        get { return UserDefaults.standard.bool(forKey: key) != isInverted }
        set (newValue) {
            UserDefaults.standard.set(newValue != isInverted, forKey: key)
            onValueChanged(newValue)
            showEnabledStateOfDependencies(newValue)
        }
    }
    convenience init(inverted:Bool, prompt: String, key: GameProperties)
    {
        self.init(inverted:inverted, prompt: prompt, key: key.rawValue,  isImmediate: false)
    }
    convenience init(inverted:Bool, prompt: String, key: GameProperties, isImmediate: Bool)
    {
        self.init(inverted:inverted, prompt: prompt, key: key.rawValue,  isImmediate: isImmediate)
    }
    public init(inverted:Bool, prompt: String, key: String, isImmediate: Bool)
    {
        self.isInverted = inverted
       
        super.init(defaultValue: inverted, key: key) { DisplayedYesNo(current: inverted, text: prompt.localize)}
        
        if isImmediate {
            let oldOnChange = displayed.onValueChanged
            displayed.onValueChanged = { [weak self] newValue in
                if let s = self { s.value =  newValue }
                oldOnChange(newValue)
            }
        }
        showEnabledStateOfDependencies(self.value)
    }
    fileprivate func showEnabledStateOfDependencies(_ newValue: Bool) {
        for var dependency in dependencies { dependency.enabled = newValue }
    }
}
