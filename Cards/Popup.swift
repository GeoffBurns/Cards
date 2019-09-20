//
//  Popup.swift
//  Cards
//
//  Created by Geoff Burns on 24/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

public extension CGPoint {

     func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    

     func lengthSquared() -> CGFloat {
        return x*x + y*y
    }
}
    public func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }


public enum PopupType : CustomStringConvertible
{
    case rulesScreen
    case optionScreen
    case exitScreen
    case cardDisplayScreen

    
    public var description : String {
        switch self {
            
        case .rulesScreen: return "RulesScreen"
        case .optionScreen: return "OptionScreen"
        case .exitScreen: return "ExitScreen"
        case .cardDisplayScreen: return "CardDisplayScreen"
   
        }}
}
// Popup screen for user input
open class Popup: SKSpriteNode {
    
    public weak var gameScene : SKNode? = nil
    public weak var button :  PopupButton? = nil
    public var startTouchPosition = CGPoint.zero

    

    open func setup(_ gameScene : SKNode)
    {
        self.gameScene = gameScene
 
    }
    
    public init()
    {
        super.init(texture: nil, color: UIColor(red: 0.0, green: 0.3, blue: 0.1, alpha: 0.9), size:  CGSize(width: 1, height: 1))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    open func onEnter()
    {
        
    }
    
    open func onExit()
    {
        self.removeAllChildren()
    }
}

open class MultiPagePopup : Popup,  Resizable {
    var moreButton = SKSpriteNode(imageNamed: "More1")
    var backButton = SKSpriteNode(imageNamed: "Back")
    var exitButton = SKSpriteNode(imageNamed: "Exit")
    
    public var tabButtons : [SKSpriteNode] = []
    public var tabNo = 0 { didSet { updateTab()   }}
    open var pageNo = 0
    public var tabNames : [String] = []
    public var adHeight = CGFloat(0)
    public var exiting = false
    func updateTab()
    {
        if tabButtons.count == 0 || tabNo < 0 || tabButtons.count <= tabNo { return }
        let tabButton = tabButtons[self.tabNo]
        
        let textureName = (tabButton.name! + "2")
        tabButton.texture = SKTexture(imageNamed: textureName)
        let otherTabs = tabButtons
            .filter { $0.name  != tabButton.name }
        
        for otherTab in otherTabs
        {
            otherTab.texture = SKTexture(imageNamed: (otherTab.name! + "1"))
        }
    }
    
    
    open func arrangeLayoutFor(_ size:CGSize, bannerHeight:CGFloat)
    {
        adHeight = bannerHeight
        let top : CGFloat = size.isPortrait ? 0.97 : 0.99
        let bottomRight = DeviceSettings.isPhoneX
            ? CGPoint(x:size.width-10.0,y:bannerHeight+5.0)
            : CGPoint(x:size.width,y:bannerHeight)
        let bottomLeft =  DeviceSettings.isPhoneX
            ? CGPoint(x:10.0,y:bannerHeight+5.0)
            : CGPoint(x:0.0,y:bannerHeight)
    
        let topRight = DeviceSettings.isPhoneX
            ? CGPoint(x:size.width-10.0,y:size.height * top + bannerHeight)
            : CGPoint(x:size.width,y:size.height * top + bannerHeight)
        let topLeft = DeviceSettings.isPhoneX
            ? CGPoint(x:10.0,y:size.height * top + bannerHeight)
            : CGPoint(x:0.0,y:size.height * top + bannerHeight)
        moreButton.position = bottomRight
        backButton.position = bottomLeft
        exitButton.position = topRight

   
        for tabButton in tabButtons
        {
            tabButton.position = topLeft
        }
    }
    
    public func displayButtons()
    {
        //arrangeLayoutFor(self.frame.size)
        
        moreButton.setScale(ButtonSize.small.scale)
        moreButton.anchorPoint = CGPoint(x: 1.0, y: 0.0)
        
        moreButton.name = "More"
        
        moreButton.zPosition = 100
        moreButton.isUserInteractionEnabled = false
        
        moreButton.addSafelyTo(self)
        
        backButton.setScale(ButtonSize.small.scale)
        backButton.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        backButton.name = "Back"
        backButton.zPosition = 100
        backButton.isUserInteractionEnabled = false
        
        backButton.addSafelyTo(self)
        
        exitButton.setScale(ButtonSize.small.scale)
        exitButton.anchorPoint = CGPoint(x: 1.0, y: 1.0)
        
        exitButton.name = "Exit"
        
        exitButton.zPosition = 100
        exitButton.isUserInteractionEnabled = false
        
       
        exitButton.addSafelyTo(self)
        
        let topLeft = DeviceSettings.isPhoneX
            ? CGPoint(x:10.0,y:self.frame.size.height)
            : CGPoint(x:0.0,y:self.frame.size.height)
        if tabButtons.count == 0
         {
          for (i,tabName) in tabNames.enumerated()
           {
            let imageName = tabName + (i == tabNo ? "2" : "1")
            let tabButton = SKSpriteNode(imageNamed: imageName)
            tabButton.setScale(ButtonSize.small.scale)
            tabButton.anchorPoint = CGPoint(x: CGFloat(-i), y: 1.0)
            tabButton.position = topLeft
            
            tabButton.name = tabName
            
            tabButton.zPosition = 300
            tabButton.isUserInteractionEnabled = false
            
            tabButtons.append(tabButton)
            self.addChild(tabButton)
           }
         }
    }
    
    // overriden in derived class
    open func newPage()
    {
    }
    open func exit()
    {
        exiting = true
        removeFromParent()
    }
    // overriden in derived class
    open func noPageFor(_ tab:Int) -> Int
    {
        return 1
    }
    func nextPage()
    {
        self.pageNo += 1
     
       if self.pageNo >= noPageFor(self.tabNo)
        {
            if  tabNames.count == 0
            {
                self.pageNo = 0
            }
            else
            {
            self.pageNo = 0
            self.tabNo = self.tabNo+1 >= tabNames.count ? 0 : self.tabNo+1
            }
        }
        newPage()
    }
    func prevPage()
    {
        self.pageNo -= 1
        
        if self.pageNo < 0
        {
            
            if  tabNames.count > 0
            {
            self.tabNo = self.tabNo <= 0 ?  tabNames.count-1 : self.tabNo-1
            self.pageNo = noPageFor(self.tabNo) - 1
            }
            else
            {
                self.pageNo = noPageFor(0) - 1
            }
        }
        newPage()
    }
    func buttonTouched(_ positionInScene:CGPoint) -> Bool
    {
        if let touchedNode : SKSpriteNode = self.atPoint(positionInScene) as? SKSpriteNode,
            let nodeName =  touchedNode.name
        {
            
            let buttons = tabButtons
                .enumerated()
                .filter { (i,tabButton) in return i != self.tabNo && tabButton.name == nodeName }
            
            for (i,_) in buttons
            {
                self.pageNo = 0
                self.tabNo = i
                newPage()
                return true
                
                
            }
            switch nodeName
            {
            case "More" :
                nextPage()
                return true
            case "Back" :
                prevPage()
                return true
            case "Exit" :
                exit()
                return true
            default:
                return false
                
            }
        }
        
        return false
    }
    
    open func cardTouched(_ positionInScene:CGPoint) -> Bool
    {
        return false
    }
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        
        if let t = touches.first
        {
            startTouchPosition = t.location(in: self)
        }
        for touch in (touches )
        {
            let positionInScene = touch.location(in: self)
            
            if buttonTouched(positionInScene) { return }
            if cardTouched(positionInScene) { return }
        }
    }


    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if exiting { return }
        if let t = touches.first
        {
          let  endTouchPosition = t.location(in: self)
          let  displacement = endTouchPosition - startTouchPosition
          if displacement.lengthSquared() > 4000 && 2*abs(displacement.x) < abs(displacement.y)
          {
            if displacement.y < 0
            {
                nextPage()
            }
            else
            {
                prevPage()
            }
          }
        }
    }
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
     //   if let touches = touches {
            touchesEnded(touches, with: event)
    //    }
    }
}
