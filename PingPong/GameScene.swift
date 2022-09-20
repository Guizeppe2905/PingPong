//
//  GameScene.swift
//  PingPong
//
//  Created by Мария Хатунцева on 18.09.2022.
//

import SpriteKit
import GameplayKit
import Combine

class GameScene: SKScene {
    
    var storage: Set<AnyCancellable> = []
    var background = SKSpriteNode(imageNamed: "background")

    var ball = SKSpriteNode()
    var player = SKSpriteNode()
    var enemy = SKSpriteNode()
    var playerScore = SKLabelNode()
    var enemyScore = SKLabelNode()
    var playerPoints: Int = 0
    var enemyPoints: Int = 0

    var score = PassthroughSubject<[Int], Never>()
     
    override func didMove(to view: SKView) {
        background.position = CGPoint(x: 0, y: 0)
        background.size.width = self.size.width
        background.size.height = self.size.height
        background.anchorPoint = CGPoint(x: 0.5,y: 0.5)
        background.zPosition = -1.0
        self.addChild(background)
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        ball.zPosition = 0.0
        player = self.childNode(withName: "player") as! SKSpriteNode
        player.position.y = (-self.frame.height / 2) + 70
        player.zPosition = 0.0
        enemy = self.childNode(withName: "enemy") as! SKSpriteNode
        enemy.position.y = (self.frame.height / 2) - 70
        enemy.zPosition = 0.0
        playerScore = self.childNode(withName: "playerScore") as! SKLabelNode
        playerScore.zPosition = 0.0
        enemyScore = self.childNode(withName: "enemyScore") as! SKLabelNode
        enemyScore.zPosition = 0.0
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        self.physicsBody = border
        startGame()
    }
    
    func startGame() {
        playerPoints = 0
        enemyPoints = 0
        score
            .sink { value in
                self.playerScore.text = "\(value[0])"
                self.enemyScore.text = "\(value[1])"
            }
            .store(in: &storage)
        score.send([playerPoints, enemyPoints])
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        ball.physicsBody?.applyImpulse(CGVector(dx: 15 , dy: 15))
    }

    func addScore(winner: SKSpriteNode) {
        if UserSettings.shared.reset == false {
            ball.position = CGPoint(x: 0, y: 0)
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            if winner == player {
                playerPoints += 1
                score.send([playerPoints, enemyPoints])
                ball.physicsBody?.applyImpulse(CGVector(dx: 15, dy: 15))
            } else if winner == enemy {
                enemyPoints += 1
                score.send([playerPoints, enemyPoints])
                ball.physicsBody?.applyImpulse(CGVector(dx: -15, dy: -15))
            }
            score.send([playerPoints, enemyPoints])
        } else {
            startGame()
            UserSettings.shared.reset = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            player.run(SKAction.moveTo(x: location.x, duration: 0.0))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            player.run(SKAction.moveTo(x: location.x, duration: 0.0))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        enemy.run(SKAction.moveTo(x: ball.position.x, duration: 1.0))
        if UserSettings.shared.reset == true {
            ball.position = CGPoint(x: 0, y: 0)
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            ball.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 10))
            addScore(winner: player)
            UserSettings.shared.reset = false
        }
        if ball.position.y <= player.position.y - 40 {
            addScore(winner: enemy)
        } else if ball.position.y >= enemy.position.y + 40 {
            addScore(winner: player)
        }
    }

}
