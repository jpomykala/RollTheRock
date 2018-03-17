//
//  GameScene.swift
//  RollTheRock
//
//  Created by Jakub Pomykała on 10/3/17.
//  Copyright © 2017 Jakub Pomykała. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player = Player()
    let cam = SKCameraNode()
    var sky: SKSpriteNode?
    var sun = SKLightNode()
    var motionManager = CMMotionManager()
    var playerCanJump = true
    var rain = SKEmitterNode(fileNamed: "Rain.sks")
    
    override func sceneDidLoad() {
    }
    
    override func didMove(to view: SKView) {
        
        motionManager.deviceMotionUpdateInterval = 1.0 / 30.0
        motionManager.startDeviceMotionUpdates()
        
        
//        let playSound = SKAction.playSoundFileNamed("rock-1.mp3", waitForCompletion: false)
//        let repeatSound = SKAction.repeatForever(playSound)
//        run(repeatSound)
        self.physicsWorld.contactDelegate = self
        
        self.camera = cam
        let path = generatePath()
        let ground = SKShapeNode(path: path)
        let body = SKPhysicsBody(edgeChainFrom: path)
        body.isDynamic = false
        body.usesPreciseCollisionDetection = true
        body.fieldBitMask = 0xFFFFFFFF
        body.categoryBitMask = 0xFFFFFFFF
        body.collisionBitMask = 0xFFFFFFFF
        body.contactTestBitMask = 0xFFFFFFFF
        body.restitution = 0.8
        ground.physicsBody = body
        let groundTexture = SKTexture(imageNamed: "ground")
        groundTexture.filteringMode = .nearest
        
        ground.fillTexture = groundTexture
        ground.strokeColor = UIColor.brown
        ground.lineWidth = 4
        ground.fillColor = UIColor.brown
        
        
        
        sky = SKSpriteNode(imageNamed: "sky")
        sky?.size.height = self.size.height * 1.5
        sky?.size.width = self.size.width * 1.5
        sky?.colorBlendFactor = 0.1
        
        sun.categoryBitMask = 1
        sun.falloff = 0.1
        sun.ambientColor = UIColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 0.9)
        sun.lightColor = SKColor(red: 255/255, green: 240/255, blue: 220/255, alpha: 0.95)
        sun.shadowColor = SKColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.03)
        
        
        sky!.lightingBitMask = 1
        sky!.shadowCastBitMask = 0
        sky!.shadowedBitMask = 0
        
        
        
        sky?.zPosition = 0.1
        sun.zPosition = 0.2
        player.zPosition = 0.3
        rain?.zPosition = 0.4
        ground.zPosition = 0.5
        
        addChild(sun)
        addChild(player)
        addChild(ground)
        addChild(sky!)
        addChild(rain!)
    }
    
    
    func generatePath() -> CGPath {
        
        let cgpath = CGMutablePath();
        
        let xStart: CGFloat = CGFloat(0);
        let xEnd: CGFloat = CGFloat(15000.0);
        
        let yStart : CGFloat = 0
        let yEnd : CGFloat = -50
        
        cgpath.move(to: CGPoint(x: xStart, y: yStart))
        
        let totalWidth = Int(abs(xStart) + abs(xEnd))
        let totalHeight = Int(abs(yStart) + abs(yEnd))
        let numberOfPoints = 200
        let widthPerPoint = Int(totalWidth / numberOfPoints)
        var currentXPosition = Int(xStart)
        var nextYPosition = Double(yStart)
        
        for _ in 1...numberOfPoints {
            
            currentXPosition += widthPerPoint
            let random = drand48()
            nextYPosition -= random * 40
            let nextPoint = CGPoint(x: currentXPosition, y: Int(nextYPosition))
            cgpath.addLine(to: nextPoint)
            
        }
        
        cgpath.addLine(to: CGPoint(x: Int(xStart), y: Int(yEnd) - 100*totalHeight))
        cgpath.closeSubpath()
        return cgpath;
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        playerCanJump = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if playerCanJump == true {
            self.player.jump()
            playerCanJump = false
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        cam.position = player.position
        sky?.position = player.position
        sun.position.x = player.position.x + 600
        sun.position.y = player.position.y + 600
        rain?.position.x = player.position.x
        rain?.position.y = player.position.y + 800
        
        
        if player.position.y < -4000 {
            player.resetPosition()
        }
        
        if let attitude = motionManager.deviceMotion?.attitude {
            let pitch = CGFloat(-attitude.pitch * 2 / Double.pi)
            
            
            if(abs(pitch) > 0.05) {
                self.player.roll(force: CGVector(dx: -(70.0 * pitch), dy: 0))
            }
        }
        
    }
}
