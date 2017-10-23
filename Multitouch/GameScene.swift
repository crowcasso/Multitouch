//
//  GameScene.swift
//  Multitouch
//
//  Created by Joel Hollingsworth on 10/20/17.
//  Copyright © 2017 Joel Hollingsworth. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    // used to build all of the other circles
    private var circleNode : SKShapeNode?
    
    // associative array tying UITouches to the circle on the screen
    var touchNodes = [UITouch:SKShapeNode]()
    
    // 5 colors for touch points (iPhone only allows 5 touches)
    let colors = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow, UIColor.orange]
    
    // called once
    override func didMove(to view: SKView) {
        
        // define the width of the circle (based on the screen size)
        let w = (self.size.width + self.size.height) * 0.12
        
        // create the circle
        circleNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w / 2.0)
        
        // set some properties on the circle
        circleNode?.lineWidth = 15.0
        circleNode?.isAntialiased = true
    }
    
    func createCircleForTouch(touch : UITouch) {
        
        // copy a circle, set its position, color, and add it to the scene
        if let n = self.circleNode?.copy() as! SKShapeNode? {
            n.position = touch.location(in: self)
            n.strokeColor = pickFirstColorNotInUse()
            self.addChild(n)
            
            // associate the touch with the circle
            touchNodes[touch] = n
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // loop over all touches, create a circle for that touch
        for touch in touches {
            createCircleForTouch(touch: touch)
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            // get the circle associated with the touch
            if let circle = touchNodes[touch] {
                // move the circle to the new location.
                let newLocation = touch.location(in: self)
                circle.position = newLocation
            }
        }
        
    }
    
    func removeCircleForTouch (touch : UITouch ) {
        
        // if we can find the touch, remove the circle
        if let circle = touchNodes[touch] {
            circle.removeFromParent()               // remove from scene
            touchNodes.removeValue(forKey: touch)   // remove from array
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            removeCircleForTouch(touch: touch)
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            removeCircleForTouch(touch: touch)
        }

    }
    
    // choose a color currently not in use
    func pickFirstColorNotInUse() -> UIColor {
        for color in colors {
            var colorInUse = false
            for touch in touchNodes {
                if touch.value.strokeColor == color {
                    colorInUse = true
                }
            }
            if !colorInUse {
                return color
            }
        }
        
        return UIColor.brown
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
