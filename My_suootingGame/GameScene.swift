//
//  GameScene.swift
//  My_suootingGame
//
//  Created by Yung on 2018/12/14.
//  Copyright © 2018 Yung. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    struct PhysicsCategory {
        static let none      : UInt32 = 0
        static let all       : UInt32 = UInt32.max
        static let monster   : UInt32 = 0b1       // 1
        static let projectile: UInt32 = 0b10      // 2
    }
    
    let player = SKSpriteNode(imageNamed: "DQQ")
    let playerbd = SKSpriteNode(imageNamed: "bk2")
    
    override func didMove(to view: SKView)
    {
        
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        
        // 2 準備背景顏色物件
        backgroundColor = SKColor.white
        
        //3.0 背景放入
        playerbd.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        addChild(playerbd)
        // 3 將太空船位(殺人機器ＸＤ)置放到螢幕左邊 1/100
        
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        // 4
        addChild(player)
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addMonster),
                SKAction.wait(forDuration: 1.0)
                ])
        ))
       
    }
    
    
    
    
    
    override func update(_ currentTime: TimeInterval)
    {
        // Called before each frame is rendered
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        
        // 2 - Set up initial location of projectile
        let projectile = SKSpriteNode(imageNamed: "DQ2")
        projectile.position = player.position
        
        // 3 - Determine offset of location to projectile
        let offset = touchLocation - projectile.position
        
        // 4 - Bail out if you are shooting down or backwards
        if offset.x < 0 { return }
        
        // 5 - OK to add now - you've double checked position
        addChild(projectile)
        
        // 6 - Get the direction of where to shoot
        let direction = offset.normalized()
        
        // 7 - Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000
        
        // 8 - Add the shoot amount to the current position
        let realDest = shootAmount + projectile.position
        
        // 9 - Create the actions
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.monster
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
        projectile.physicsBody?.usesPreciseCollisionDetection = true
    }

    
    
    //MARK:- 自製方便函數
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addMonster() {   //把敵人角色的程式碼做一個函數
        
        // Create 怪物角色
        let monster = SKSpriteNode(imageNamed: "manster")
        
        
        
        // 怪物沿Ｙ 最上面與最下面不能突出畫面
        let actualY = random(min: monster.size.height/2, max: size.height - monster.size.height/2)
        
        
        //把怪物加入場景 
        monster.position = CGPoint(x: size.width + monster.size.width/2, y: actualY)
        
        // Add the monster to the scene
        addChild(monster)
        
        // Determine speed of the monster
        //指定時間(亂數)
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        // 可以執行角色的移動。第一個參數 移動目標的點
        let actionMove = SKAction.move(to: CGPoint(x: -monster.size.width/2, y: actualY),
                                       duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        monster.run(SKAction.sequence([actionMove, actionMoveDone]))
        
        monster.xScale = 0.5
        monster.yScale = 0.5
        
        
        
        monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size) // 1
        monster.physicsBody?.isDynamic = true // 2
        monster.physicsBody?.categoryBitMask = PhysicsCategory.monster // 3
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.projectile // 4
        //monster.physicsBody?.collisionBitMask = PhysicsCategory.none // 5

        
    }
    
    func projectileDidCollideWithMonster(projectile: SKSpriteNode, monster: SKSpriteNode) {
        print("Hit")
        projectile.removeFromParent()
        monster.removeFromParent()
    }
    
    //MARK: - 碰撞委託
    func didBegin(_ contact: SKPhysicsContact)
    {
        print("淦 去死啦")
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 2
        if ((firstBody.categoryBitMask & PhysicsCategory.monster != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.projectile != 0)) {
            if let monster = firstBody.node as? SKSpriteNode,
                let projectile = secondBody.node as? SKSpriteNode {
                projectileDidCollideWithMonster(projectile: projectile, monster: monster)
            }
        }
        
    }
    
    
    
    

}
    func +(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }

    func -(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }

    func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: point.x * scalar, y: point.y * scalar)
    }

    func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: point.x / scalar, y: point.y / scalar)
    }

    #if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
    #endif

    extension CGPoint {
        func length() -> CGFloat {
            return sqrt(x*x + y*y)
        }
        
        func normalized() -> CGPoint {
            return self / length()
        }
    }

