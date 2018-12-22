//
//  GameOverScene.swift
//  My_suootingGame
//
//  Created by Yung on 2018/12/22.
//  Copyright © 2018 Yung. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverScene: SKScene {
    
    init(size: CGSize, won:Bool) {
        super.init(size: size)
        
        // 1
        backgroundColor = SKColor.white
        
        // 2
        let message = won ? "You Won!" : "Sorry You is GG OTZ"
        
        // 3
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 45
        label.fontColor = SKColor.red
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        // 4
        run(SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.run() { [weak self] in
                // 5
                guard let `self` = self else { return }
                
                //過場(SKTransition) 水平翻轉(flipHorizontal)
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition:reveal)
            }
            ]))
    }
    
    // 6  如果自己寫建構子 以下的建構子叫做“必要的”補充建構子
    required init(coder aDecoder: NSCoder) {
        
        //在必要的 建構子中 最少一店要寫下面這個全域函數
        //fatalError 會在類別建構失敗時被許叫 他的參數就是失敗時! 在後台顯示訊息~
        fatalError("init(coder:) has not been implemented")
    }

}
