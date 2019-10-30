//
//  OptionScreen.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 20/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

/// Game Option Setting Screen
public class OptionScreen: MultiPagePopup {
    var isSetup = false
    var multiPlayerSettings = [SKNode]()
    var gameCenterSettings = [SKNode]()
    var noOfItemsOnPage = 3
    var separationOfItems =  CGFloat(0.2)
    var startHeight =  CGFloat(0.7)
    
//    var tabNewPage = [ displayOptions, gameCentre, displayMultiplayer ]
    var tabNewPage = [ displayOptions, speakOptions, gameCentre ]
    
    public override func onEnter() {

        }
    
    public override func exit()
    {
        onExit()
    }
    
    public override func onExit()
    {
        if Game.settings.changed()
        {
            if let scene = gameScene as? HasDemoMode
            {
                scene.resetSceneAsDemo()
            }
        }
      cleanUp()
      super.onExit()
    }
    
    public override func  setup(_ scene:SKNode)
    {
        
        self.gameScene = scene
        color = UIColor(red: 0.0, green: 0.3, blue: 0.1, alpha: 0.9)
        size = scene.frame.size
        var layoutSize = size
        position = CGPoint.zero
        anchorPoint = CGPoint.zero
        
        isUserInteractionEnabled = true
        if  GameKitHelper.sharedInstance.gameCenterEnabled { self.tabNames = ["Options","Gamecentre"] }
        else { self.tabNames = ["Options"] }
        name = "Option Background"
        pageNo = 0
        
     //   optionSettings = Game.settings.options.map { $0.view }
     //   audioSettings = Game.settings.audioOptions.map { $0.view }
        multiPlayerSettings = [Options.noOfHumans.view]
     //   tabNames = ["Options","Gamecentre","multiplayer"]
        tabNames = ["Options","speak","Gamecentre"]
        if let resize = scene as? Resizable
        {
            self.adHeight = resize.adHeight
            layoutSize = CGSize(width: size.width, height: size.height - self.adHeight)
        }
        arrangeLayoutFor(layoutSize,bannerHeight: adHeight)
    }
    
    public override func noPageFor(_ tab:Int) -> Int
    {
        switch tab
        {
        case 0:
            return Game.settings.options.numOfPagesOf(noOfItemsOnPage)
        case 1:
            return Game.settings.audioOptions.numOfPagesOf(noOfItemsOnPage)
        default :
            return 1
        }
    }
    
    public override func arrangeLayoutFor(_ size:CGSize,bannerHeight:CGFloat)
    {
        if exiting { return }
        if DeviceSettings.isBigDevice {
            if DeviceSettings.isPortrait {
                if DeviceSettings.isPadPro
                {
                noOfItemsOnPage = 7
                separationOfItems =  CGFloat(0.12)
                startHeight = CGFloat(0.87)
                }
                else
                {
                    noOfItemsOnPage = 6
                    separationOfItems =  CGFloat(0.14)
                    startHeight = CGFloat(0.77)
                }
            } else {
                noOfItemsOnPage = 5
                separationOfItems =  CGFloat(0.15)
                startHeight = CGFloat(0.77)
            }
        } else {
            noOfItemsOnPage = 3
            separationOfItems =  CGFloat(0.2)
            startHeight = CGFloat(0.7)
        }
        self.size = size
   //     super.arrangeLayoutFor(size,bannerHeight:bannerHeight)
        if pageNo > noPageFor(tabNo) - 1 {
            pageNo = noPageFor(tabNo) - 1
        }
        
        super.arrangeLayoutFor(size,bannerHeight:bannerHeight)
        displayButtons()
        newPage()
    }
    
    
    func cleanUp()
    {
    
        Game.settings.options.removeAllFromParent()
        Game.settings.audioOptions.removeAllFromParent()
        multiPlayerSettings.removeAllFromParent()
        gameCenterSettings.removeAllFromParent()
    }
    public override func newPage()
    {
        if self.tabNo < 0 { return }
     
        cleanUp()
        let renderPage = self.tabNewPage[self.tabNo](self)
      
        renderPage()
    }

    /// Allow rule of the game to be changed
    func displayOptions()
    {
        let settingStart = noOfItemsOnPage*self.pageNo
  
        let optionDisplayed = Game.settings.options
            .from(settingStart, forLength: noOfItemsOnPage)
      
        optionDisplayed.addAll("Setting",
                               startHeight : startHeight,
                               separationOfItems : separationOfItems,
                               toPage: self,
                               size: self.size
                               )
    }
    func speakOptions()
    {
        let settingStart = noOfItemsOnPage*self.pageNo
        let optionDisplayed = Game.settings.audioOptions
            .from(settingStart, forLength: noOfItemsOnPage)
      
        optionDisplayed.addAll("AudioSetting",
                               startHeight : startHeight,
                               separationOfItems : separationOfItems,
                               toPage: self,
                               size: self.size
                               )
    }
    ///
    func gameCentre()
    {
      
      //  let controller = self.view.window.rootViewController
       
   /*    GameKitHelper.sharedInstance.showGKGameCenterViewController(
        controller) { self.tabNo = 0; self.pageNo = 0 ; self.newPage()}
    */
      /*  if let appDelegate = UIApplication.shared.delegate as? HasWindow ,
            let window = appDelegate.window,
            let controller = window.rootViewController
        {
            GameKitHelper.sharedInstance.showGKGameCenterViewController(
                controller) { self.tabNo = 0; self.pageNo = 0 ; self.newPage()}
        }
 */
        
      
        
        let fontsize : CGFloat = FontSize.small.scale
        let warn = SKLabelNode(fontNamed:"Verdana")
        warn.name = "Setting1"
        warn.fontSize = fontsize
        warn.position = CGPoint(x: size.width * 0.50, y: size.height * 0.50)
        warn.text = "Having trouble connecting to Game Center".localize

        
        if let window =  GameKitHelper.sharedInstance.gameView?.window,
            let controller = window.rootViewController
        {
            warn.text = "Connecting to Game Center".localize
            GameKitHelper.sharedInstance.showGKGameCenterViewController(
            controller) { self.tabNo = 0; self.pageNo = 0 ; self.newPage()}
        }
        gameCenterSettings = [warn]
        self.addChild(warn)
    }
    /// display pass the phone multiplayer mode settings
    func displayMultiplayer()
    {
        let settingStart = noOfItemsOnPage*self.pageNo
        let multiplayerSettingsDisplayed = multiPlayerSettings
            .from(settingStart, forLength: noOfItemsOnPage)
        
        let scene = gameScene!
        let midWidth = gameScene!.frame.midX
        
        for (i, multiplayerSetting) in multiplayerSettingsDisplayed.enumerated()
        {
            multiplayerSetting.name = "MSetting" + (i + 1).description
            multiplayerSetting.position = CGPoint(x:midWidth,y:scene.frame.height * (startHeight - separationOfItems * CGFloat(i)))
            self.addChild(multiplayerSetting)
        }
    }

    }
    
 
