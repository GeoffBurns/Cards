//
//  ExitScreen.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 20/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

/// Are you sure screen
public class ExitScreen: Popup , Resizable
{
    public var adHeight : CGFloat = 0.0
    var exitLabel = SKLabelNode(fontNamed:"Chalkduster")
    var exitLabel2 = SKLabelNode(fontNamed:"Chalkduster")
    let yesButton =  SKSpriteNode(imageNamed:"Yes")
    let noButton =  SKSpriteNode(imageNamed:"No")
    let hex = SKShapeNode()
    var isSetup = false
    
    public override init()
    {
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupHexBackground(_ size: CGSize) {
        let h = size.height
        let w = size.width
        var x_off : CGFloat = 0.0
        var y_off  : CGFloat = 0.0
        let h1  : CGFloat = 0.9*h
        let w1  : CGFloat = 0.9*w
        var length : CGFloat = 0.0
        if h > w {
            x_off = 0.05*w
            y_off = 0.117*w + (h1-w1) / 2.0
            length = w1
        } else {
            x_off = 0.05*h + (w1-h1) / 2.0
            y_off = 0.117*h
            
            length = h1
        }
        
        let points = [
            CGPoint(x:0.25, y:0.0),
            CGPoint(x:0.75, y:0.0),
            CGPoint(x:1.0, y:0.433),
            CGPoint(x:0.75, y:0.866),
            CGPoint(x:0.25, y:0.866),
            CGPoint(x:0.0, y:0.433),
            CGPoint(x:0.25, y:0.0)]
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x:points[0].x*length+x_off, y: points[0].y*length+y_off))
        for i in 1...6 {
            path.addLine(to: CGPoint(x:points[i].x*length+x_off, y: points[i].y*length+y_off))
        }
        
        
        hex.path = path
        hex.fillColor = UIColor(red: 0.1, green: 0.3, blue: 0.5, alpha: 1.0) //.blue
        hex.strokeColor = .white
        hex.lineWidth = 2.0
        hex.zPosition = 50
    }
    
    fileprivate func setupButtons(_ size: CGSize) {
        
        let midwidth = size.width * 0.5
        var separation = size.width * 0.25
        if size.width > size.height { separation = size.height * 0.25 }
        yesButton.position = CGPoint(x:midwidth-separation,y:size.height * 0.4)
        yesButton.setScale(ButtonSize.small.scale)
        yesButton.zPosition = 100
        yesButton.name = "Yes"
        yesButton.isUserInteractionEnabled = false
        
        noButton.position = CGPoint(x:midwidth+separation,y:size.height * 0.4)
        noButton.setScale(ButtonSize.small.scale)
        noButton.zPosition = 100
        noButton.name = "No"
        noButton.isUserInteractionEnabled = false
    }
    
    fileprivate func setupBackground() {
        button!.zPosition = 350
        color = UIColor(red: 0.0, green: 0.3, blue: 0.1, alpha: 0.9)
        position = CGPoint.zero
        anchorPoint = CGPoint.zero
        name = "ExitBackground"
        isUserInteractionEnabled = true
    }
    
      fileprivate func setupLabels(_ size: CGSize) {
        let fontsize = FontSize.huge.scale
        let midWidth = size.width*0.5
        let height = size.height
        exitLabel.text = "Are you sure".localize
        exitLabel.fontSize = fontsize;
        exitLabel.zPosition = 100
        exitLabel.position = CGPoint(x:midWidth, y: height * 0.7);
        
        exitLabel2.text = "you want to exit".localize
        exitLabel2.fontSize = fontsize;
        exitLabel2.zPosition = 100
        exitLabel2.position = CGPoint(x:midWidth, y: height * 0.57);
    }
    public override func setup(_ scene:SKNode)
    {
        self.gameScene = scene
        size = scene.frame.size
        let layoutSize = size
        setupBackground()
        setupHexBackground(layoutSize)
        self.addChild(hex)

        

        setupLabels(layoutSize)
        self.addChild(exitLabel)
        self.addChild(exitLabel2)
        
        setupButtons(layoutSize)
        
        self.addChild(yesButton)
        self.addChild(noButton)
    }

    public func arrangeLayoutFor(_ size:CGSize, bannerHeight:CGFloat)
    {
        self.size = size
        setupHexBackground(size)
        setupLabels(size)
        setupButtons(size)
    }
 
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */

        for touch in (touches )
        {
            let positionInScene = touch.location(in: self)

            if let touchedNode : SKSpriteNode = self.atPoint(positionInScene) as? SKSpriteNode
              {
              if touchedNode.name == "No"
                {
                button!.unpress()
                }
              if touchedNode.name == "Yes"
                {
                touchedNode.texture = SKTexture(imageNamed: "Yes2")
                
                if let scene = gameScene as? HasDemoMode
                    {
                    scene.resetSceneAsDemo()
                    }
                button!.unpress()
                }
            }
        }
    }
}
