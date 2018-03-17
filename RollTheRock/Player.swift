//
//  Player.swift
//  RollTheRock
//
//  Created by Jakub Pomykała on 10/3/17.
//  Copyright © 2017 Jakub Pomykała. All rights reserved.
//

import Foundation
import GameplayKit
import CoreMotion


class Player: SKSpriteNode {
    
    init() {
        let texture = SKTexture(imageNamed: "rock")
        super.init(texture: texture, color: UIColor.black, size: texture.size())
        
        resetPosition()
        
        self.lightingBitMask = 1
        self.shadowCastBitMask = 1
        self.shadowedBitMask = 1
        self.colorBlendFactor = 0.2
        
        self.normalTexture = self.texture?.generatingNormalMap(withSmoothness: 0.2, contrast: 0.2)
        
        let body = SKPhysicsBody(texture: texture, alphaThreshold: 0.05, size: texture.size())
        body.isDynamic = true
        body.usesPreciseCollisionDetection = true
        body.allowsRotation = true
        body.restitution = 0.1
        body.linearDamping = 0.95
        body.angularDamping = 0.95
        body.mass = 2
        body.friction = 0.9
        body.fieldBitMask = 0xFFFFFFFF
        body.categoryBitMask = 0xFFFFFFFF
        body.collisionBitMask = 0xFFFFFFFF
        body.contactTestBitMask = 0xFFFFFFFF
        self.physicsBody = body
    }
    
    func resetPosition(){
         self.position = CGPoint(x: 1200, y: 200)
    }
    
    
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func jump(){
        self.physicsBody!.applyImpulse(CGVector(dx: 0.0, dy: 1500.0))
    }
    
    func roll(force: CGVector){
        self.physicsBody!.applyImpulse(force)
    }
    
}
