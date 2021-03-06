//
//  AppDelegate.swift
//  HugeBeer
//
//  Created by Luis Armando Chávez Soto on 27/02/16.
//  Copyright © 2016 Yamblet. All rights reserved.
//

import Foundation
import SIFloatingCollection

import UIKit
import SpriteKit

class BubbleNode: SIFloatingNode {
    var labelNode = SKLabelNode(fontNamed: "")
    var burbbleName:String!
    var burbbleBackgroundColor = SKColor()
    var burbbleStrokeColor = SKColor()
    var burbbleRadius = CGFloat()
    
    static func multipleLineText(labelInPut: SKLabelNode) -> SKLabelNode {
        let subStrings:[String] = labelInPut.text!.componentsSeparatedByString("\n")
        var labelOutPut = SKLabelNode()
        var subStringNumber:Int = 0
        for subString in subStrings {
            let labelTemp = SKLabelNode(fontNamed: labelInPut.fontName)
            labelTemp.text = subString
            labelTemp.fontColor = labelInPut.fontColor
            labelTemp.fontSize = labelInPut.fontSize
            labelTemp.position = labelInPut.position
            labelTemp.horizontalAlignmentMode = labelInPut.horizontalAlignmentMode
            labelTemp.verticalAlignmentMode = labelInPut.verticalAlignmentMode
            let y:CGFloat = CGFloat(subStringNumber) * labelInPut.fontSize
            if subStringNumber == 0 {
                labelOutPut = labelTemp
                subStringNumber++
            } else {
                labelTemp.position = CGPoint(x: 0, y: -y)
                labelOutPut.addChild(labelTemp)
                subStringNumber++
            }
        }
        return labelOutPut
    }
    
    class func instantiate(name:String, radius:CGFloat, strokeColor:SKColor, backgroundColor:SKColor) -> BubbleNode! {
        let node = BubbleNode(circleOfRadius: radius)
        node.burbbleBackgroundColor = backgroundColor
        node.burbbleStrokeColor = strokeColor
        node.burbbleName = name
        configureNode(node)
        return node
    }
    
    class func configureNode(node: BubbleNode!) {
        let boundingBox = CGPathGetBoundingBox(node.path);
        let radius = boundingBox.size.width / 2.0;
        node.physicsBody = SKPhysicsBody(circleOfRadius: radius + 1.5)
        node.fillColor = node.burbbleBackgroundColor
        node.strokeColor = node.burbbleStrokeColor
        
        node.labelNode.text = node.burbbleName
        node.labelNode.position = CGPointZero
        node.labelNode.fontColor = SKColor.blackColor()
        node.labelNode.fontSize = 10
        node.labelNode.userInteractionEnabled = false
        node.labelNode.verticalAlignmentMode = .Center
        node.labelNode.horizontalAlignmentMode = .Center
        node.labelNode = self.multipleLineText(node.labelNode)
        node.addChild(node.labelNode)
    }
    
    override func selectingAnimation() -> SKAction? {
        removeActionForKey(BubbleNode.removingKey)
        return SKAction.scaleTo(1.4, duration: 0.2)
    }
    
    override func normalizeAnimation() -> SKAction? {
        removeActionForKey(BubbleNode.removingKey)
        return SKAction.scaleTo(1, duration: 0.2)
    }
    
    override func removeAnimation() -> SKAction? {
        removeActionForKey(BubbleNode.removingKey)
        return SKAction.fadeOutWithDuration(0.2)
    }
        
    override func removingAnimation() -> SKAction {
        let pulseUp = SKAction.scaleTo(xScale + 0.13, duration: 0)
        let pulseDown = SKAction.scaleTo(xScale, duration: 0.3)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        let repeatPulse = SKAction.repeatActionForever(pulse)
        return repeatPulse
    }
}

extension String {
    
    func replaceCharacters(characters: String, toSeparator: String) -> String {
        let characterSet = NSCharacterSet(charactersInString: characters)
        let components = self.componentsSeparatedByCharactersInSet(characterSet)
        let result = components.joinWithSeparator("")
        return result
    }
    
    func wipeCharacters(characters: String) -> String {
        return self.replaceCharacters(characters, toSeparator: "")
    }
}