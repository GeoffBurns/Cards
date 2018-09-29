//
//  SKMultilineLabel.swift
//
//  Created by Craig on 10/04/2015.
//  Copyright (c) 2015 Interactive Coconut. All rights reserved.
//
/*   USE:

(most component parameters have defaults)

let multiLabel = SKMultilineLabel(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", labelWidth: 250, pos: CGPoint(x: size.width / 2, y: size.height / 2))
self.addChild(multiLabel)

*/

import SpriteKit

public class SKMultilineLabel: SKNode {
    //props
    public var labelWidth:Int {didSet {update()}}
    public var labelHeight:Int = 0
    public var labelHeightMax:CGFloat = 0.0
    public var pageBreak : CGFloat = 0.0
    public var pageLength : CGFloat = 0.0
    public var text:String {didSet {update()}}
    public var fontName:String {didSet {update()}}
    public var fontSize:CGFloat {didSet {update()}}
    public var pos:CGPoint {didSet {update()}}
    public var fontColor:UIColor {didSet {update()}}
    public var leading:Int {didSet {update()}}
    public var alignment:SKLabelHorizontalAlignmentMode {didSet {update()}}
    public var dontUpdate = false
    public var shouldShowBorder:Bool = false {didSet {update()}}
    //display objects
    public var rect:SKShapeNode?
    public var labels:[SKLabelNode] = []
    public var page:Int {didSet {update()}}
    public var noOfPages = 0

    
    public init(text:String, labelWidth:Int, maxHeight:CGFloat, pageBreak:CGFloat, pos:CGPoint, fontName:String="Verdana",fontSize:CGFloat=10,fontColor:UIColor=UIColor.black,leading:Int=10, alignment:SKLabelHorizontalAlignmentMode = .center, shouldShowBorder:Bool = false)
    {
        self.text = text
        self.labelWidth = labelWidth
        self.pos = pos
        self.fontName = fontName
        self.fontSize = fontSize
        self.fontColor = fontColor
        self.leading = leading
        self.shouldShowBorder = shouldShowBorder
        self.alignment = alignment
        self.labelHeightMax = maxHeight
        self.pageBreak = pageBreak
        self.pageLength = maxHeight+pageBreak
        self.page = 0
        super.init()
        
        self.update()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //if you want to change properties without updating the text field,
    //  set dontUpdate to false and call the update method manually.
    public func update() {
        if (dontUpdate) {return}
        if (labels.count>0) {
            for label in labels {
                label.removeFromParent()
            }
            labels = []
        }
        let separators = CharacterSet.whitespacesAndNewlines
        let words = text.components(separatedBy: separators)
        
        var finalLine = false
        var wordCount = -1
        var lineCount = 0
        var yPos : CGFloat = 0.0
        var yPosWithBreak : CGFloat = 0.0
        var pageCount : CGFloat = 0.0
        var pagesSoFar : CGFloat = 0.0
        while (!finalLine) {
            lineCount += 1
            var lineLength = CGFloat(0)
            var lineString = ""
            var lineStringBeforeAddingWord = ""
            
            // creation of the SKLabelNode itself
            let label = SKLabelNode(fontNamed: fontName)
            // name each label node so you can animate it if u wish
            label.name = "line\(lineCount)"
            label.horizontalAlignmentMode = alignment
            label.fontSize = fontSize
            label.fontColor = UIColor.white
 

            while lineLength < CGFloat(labelWidth)
            {
                wordCount += 1
                if wordCount > words.count-1
                {
                    //label.text = "\(lineString) \(words[wordCount])"
                    finalLine = true
                    break
                }
                else
                {
                    lineStringBeforeAddingWord = lineString
                    lineString = "\(lineString) \(words[wordCount])"
                    label.text = lineString
                    lineLength = label.frame.size.width
                }
            }
            if lineLength > 0 {
                wordCount -= 1
                if (!finalLine) {
                    lineString = lineStringBeforeAddingWord
                }
                label.text = lineString
                var linePos = pos
                if (alignment == .left) {
                    linePos.x -= CGFloat(labelWidth / 2)
                } else if (alignment == .right) {
                    linePos.x += CGFloat(labelWidth / 2)
                }
                yPos = CGFloat(leading * lineCount)
                pageCount = ceil(yPos / self.labelHeightMax)
                pagesSoFar = floor(yPos / self.labelHeightMax)
                yPosWithBreak = yPos + pagesSoFar * self.pageBreak
                let labelhiegth =  CGFloat(pos.y) -  CGFloat(yPosWithBreak) + CGFloat(page) *  CGFloat(pageLength)
                linePos.y = labelhiegth
                label.position = CGPoint( x: linePos.x , y: linePos.y )
                self.addChild(label)
                labels.append(label)
                //println("was \(lineLength), now \(label.width)")
            }
            
        }
        noOfPages = Int(pageCount)
        labelHeight = lineCount * leading
      
    }
    public func insurePageIsInRange() {
        if page < 0 { page = 0}
        if page >= noOfPages { page = noOfPages-1 }
        
    }
    /*
    func isOnPage(line:Int) -> Bool {
      
        if line < pageStart[page] { return false }
        if page == pageStart.count-1 { return true }
        if line >= pageStart[page+1]  { return false }
        return true
    }*/
    
    func showBorder() {


    }
}
