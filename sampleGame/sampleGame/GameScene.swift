//
//  GameScene.swift
//  sampleGame
//
//  Created by 島田洋輝 on 2016/03/14.
//  Copyright (c) 2016年 Hiroki Shimada. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let enemy = SKSpriteNode(imageNamed: "enemy")
     let char = SKSpriteNode(imageNamed: "Char")
    
    enum State {
        case Playing
        case GameClear
        case GameOver
    }
    var state = State.Playing
    
    override func didMoveToView(view: SKView) {
        let fieldImageLength: CGFloat = 32
        for i in 0...Int(frame.size.width / fieldImageLength) + 1 {
            for j in 0...Int(frame.size.height / fieldImageLength) + 1 {
                let field = SKSpriteNode(imageNamed: "Field")
                field.position = CGPoint(x: CGFloat(i) * fieldImageLength, y: CGFloat(j) * fieldImageLength)
                field.zPosition = -1
                addChild(field)
            }
        }
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self // 今回追加部分
        
        char.position = CGPoint(x:250, y:300)
        char.physicsBody = SKPhysicsBody(rectangleOfSize: char.size)
        char.physicsBody?.contactTestBitMask = 0x1
        addChild(char)
        
        enemy.position = CGPoint(x:50, y:300)
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.size)
        addChild(enemy)
    }
    
    override func update(currentTime: NSTimeInterval) {
        if state == .Playing {
            enemy.position.x += 1
            
            if frame.width < enemy.position.x {
                state = .GameOver
                
                let myLabel = SKLabelNode(fontNamed: "HiraginoSans-W6")
                myLabel.text = "ゲームオーバー"
                myLabel.fontSize = 45
                myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 20)
                addChild(myLabel)
            }
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        state = .GameClear
        enemy.removeFromParent()
        
        let myLabel = SKLabelNode(fontNamed: "HiraginoSans-W6")
        myLabel.text = "ゲームクリア"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 20)
        addChild(myLabel)
    }
    
}