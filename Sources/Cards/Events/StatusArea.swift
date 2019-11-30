//
//  StatusArea.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 17/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import SpriteKit
import RxSwift

// Tells the game player what is going on
public class StatusDisplay : Resizable
{
    private let disposeBag = DisposeBag()
    public var adHeight = CGFloat(0.0)
    var noticeLabel2 = Label(fontNamed:"Chalkduster")
    var noticeLabel = Label(fontNamed:"Chalkduster")
 
    public static let sharedInstance = StatusDisplay()
    fileprivate init() { }
    
    public static func register(_ scene: SKNode)
    {
        StatusDisplay.sharedInstance.setupStatusArea(scene)
    }
    
    public func setDemoMode()
    {
        Tips.setToDemoMode()
        noticeLabel.displayTime = 4
        noticeLabel2.displayTime = 4
    }
    
    public func setGameMode()
    {
        Tips.setToSinglePlayerMode()
        noticeLabel.displayTime = 6
        noticeLabel2.displayTime = 6
    }
    public func setMultiplayerMode()
       {
        Tips.setToMultiplayerMode()
           noticeLabel.displayTime = 6
           noticeLabel2.displayTime = 6
       }
    public func arrangeLayoutFor(_ size:CGSize, bannerHeight:CGFloat)
    {
        let fontsize : CGFloat = FontSize.huge.scale
        adHeight = bannerHeight

        noticeLabel.position = CGPoint(x:size.width * 0.5, y:size.height *  (DeviceSettings.isPhoneX ? 0.28 : (DeviceSettings.isPhone ? 0.28 :0.33)) + bannerHeight);
        noticeLabel2.position = CGPoint(x:size.width * 0.5, y:size.height * (DeviceSettings.isPhoneX ? 0.72 : (DeviceSettings.isPhone ? 0.72 :0.68)) + bannerHeight);
        
        noticeLabel.fontSize = fontsize;
        
        noticeLabel2.fontSize = fontsize;
    }
    public func setupStatusArea(_ scene: SKNode)
    {
    noticeLabel2 = Game.settings.showTips
            ? Label(fontNamed:"Chalkduster").withShadow().withFadeOut()
            : Label(fontNamed:"Chalkduster").withShadow().withFadeInOut()
        
    noticeLabel = Game.settings.showTips
            ? Label(fontNamed:"Chalkduster").withShadow().withFadeOutAndAction
                {  Bus.send(GameNotice.showTip(Tips.random)) }
            : Label(fontNamed:"Chalkduster").withShadow().withFadeInOut()
    noticeLabel.resetToScene(scene)
    noticeLabel2.resetToScene(scene)
    arrangeLayoutFor(scene.frame.size,bannerHeight: 0.0)

    Bus.sharedInstance.notices
        . filter { $0.description != nil }
        . map { $0.line2! }
                   .bind(to: noticeLabel.rx.text)
                   .disposed(by: disposeBag)
        
    Bus.sharedInstance.notices
           . filter { $0.description != nil }
           . map { $0.line1! }
                      .bind(to: noticeLabel2.rx.text)
                      .disposed(by: disposeBag)

    
    }
   

}
