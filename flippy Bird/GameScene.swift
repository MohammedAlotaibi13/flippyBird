//
//  GameScene.swift
//  flippy Bird
//
//  Created by محمد عايض العتيبي on 21/06/1439 AH.
//  Copyright © 1439 code schoole. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene , SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode()
    var bg = SKSpriteNode()
    var pipe1 = SKSpriteNode()
    var pipe2 = SKSpriteNode()
    var scoreLabel = SKLabelNode()
    var gameOver = false
    var timer = Timer()
    var score = 0
    enum colliderType : UInt32 {
        case bird = 1
        case object = 2
        case gap = 4
    }
    
    
    @objc func makePips(){
        let movePipe = SKAction.move(by: CGVector(dx: -2 * self.frame.width  , dy: 0  ), duration:TimeInterval(self.frame.width / 100))
        let gapHight = bird.size.height * 4
        let movmentHight = arc4random() % UInt32(self.frame.height / 2)
        let pipeOffset = CGFloat(movmentHight) - self.frame.height / 4
        let pipeTexture = SKTexture(imageNamed: "pipe1.png")
        pipe1 = SKSpriteNode(texture: pipeTexture)
        pipe1.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY / 2 + pipeTexture.size().height / 2 + gapHight / 2 + pipeOffset)
        self.addChild(pipe1)
        pipe1.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
        pipe1.physicsBody?.isDynamic = false
        pipe1 .physicsBody!.contactTestBitMask = colliderType.object.rawValue
        pipe1.physicsBody!.categoryBitMask = colliderType.object.rawValue
        pipe1.physicsBody?.collisionBitMask = colliderType.object.rawValue
        pipe1.run(movePipe)
        pipe1.zPosition = -1
        let pipe2Texture = SKTexture(imageNamed: "pipe2.png")
        
        pipe2 = SKSpriteNode(texture: pipe2Texture)
        pipe2.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midX / 2  - pipe2Texture.size().height / 2 - gapHight / 2 + pipeOffset)
        self.addChild(pipe2)
        pipe2.physicsBody = SKPhysicsBody(rectangleOf: pipe2Texture.size())
        pipe2.physicsBody?.isDynamic = false
        pipe2 .physicsBody!.contactTestBitMask = colliderType.object.rawValue
        pipe2.physicsBody!.categoryBitMask = colliderType.object.rawValue
        pipe2.physicsBody?.collisionBitMask = colliderType.object.rawValue
        pipe2.zPosition = -1
        pipe2.run(movePipe)
        
        let gap = SKNode()
        gap.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + pipeOffset)
        gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeTexture.size().width , height: gapHight))
        gap.physicsBody!.isDynamic = false
        gap.run(movePipe)
        gap .physicsBody!.contactTestBitMask = colliderType.bird.rawValue
        gap.physicsBody!.categoryBitMask = colliderType.gap.rawValue
        gap.physicsBody?.collisionBitMask = colliderType.gap.rawValue
        self.addChild(gap)
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        if gameOver == false {
        if contact.bodyA.categoryBitMask == colliderType.gap.rawValue || contact.bodyB.categoryBitMask == colliderType.gap.rawValue {
           
            score += 1
            scoreLabel.text = String(score)
            
        } else {
          var gameOverLabel = SKLabelNode()
           self.speed = 0
           timer.invalidate()
            gameOver = true
            gameOverLabel.fontName = "Helvetica"
            gameOverLabel.fontSize = 30
            gameOverLabel.text = "Game Over! Tap to play again"
            gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            self.addChild(gameOverLabel)
        }
    }
    }
    override func didMove(to view: SKView) {
            self.physicsWorld.contactDelegate = self
             setUpGame()

    }
    
    func setUpGame(){
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.makePips), userInfo: nil, repeats: true)
        // bachground
        let bgTexture = SKTexture(imageNamed: "bg.png")
        let moveBgAnimation = SKAction.moveBy(x: -bgTexture.size().width, y: 0, duration: 7)
        let shiftBgAnimation = SKAction.moveBy(x: bgTexture.size().width, y: 0, duration: 0)
        let makeBgMove = SKAction.repeatForever(SKAction.sequence([moveBgAnimation , shiftBgAnimation]))
        var i : CGFloat = 0
        while i < 3 {
            
            
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: bgTexture.size().width * i, y: self.frame.midY)
            bg.size.height = self.frame.height
            self.addChild(bg)
            bg.zPosition = -2
            bg.run(makeBgMove)
            
            i += 1
            
        }
        // bird
        
        let birdTexture = SKTexture(imageNamed: "flappy1.png")
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
        
        let animattion = SKAction.animate(with: [birdTexture , birdTexture2], timePerFrame: 0.1)
        let makeBirfFlap = SKAction.repeatForever(animattion)
        bird = SKSpriteNode(texture: birdTexture)
        bird.position = CGPoint(x: self.frame.midX , y: self.frame.midY)
        bird.run(makeBirfFlap)
        self.addChild(bird)
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height / 2)
        bird.physicsBody!.isDynamic = false
        bird .physicsBody!.contactTestBitMask = colliderType.object.rawValue
        bird.physicsBody!.categoryBitMask = colliderType.bird.rawValue
        bird.physicsBody?.collisionBitMask = colliderType.bird.rawValue
        // ground
        let ground = SKNode()
        ground.position = CGPoint(x: self.frame.midX, y: -self.frame.height / 2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        ground.physicsBody!.isDynamic = false
        self.addChild(ground)
        ground .physicsBody!.contactTestBitMask = colliderType.object.rawValue
        ground.physicsBody!.categoryBitMask = colliderType.object.rawValue
        ground.physicsBody?.collisionBitMask = colliderType.object.rawValue
        
        // scoreLabel
        
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2 - 70)
        self.addChild(scoreLabel)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameOver == false {
         bird.physicsBody?.isDynamic = true
         bird.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
         bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 80))
        } else {
            gameOver = false
            score = 0
            self.speed = 1
            self.removeAllChildren()
            setUpGame()
            
        }
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
