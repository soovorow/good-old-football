//
//  GameScene.swift
//  Good Old FootBall
//
//  Created by Dmitry Suvorov on 15/11/2018.
//  Copyright © 2018 Dmitry Suvorov. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

enum PlayerRole {
    case player, enemy
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameViewController: GameViewController?
    
    var background = SKSpriteNode()
    var ball = SKSpriteNode()
    var ballSprite = SKSpriteNode()
    var ballSpinningFrames: [SKTexture] = []
    
    var ballshadow = SKSpriteNode()
    var enemy = SKSpriteNode()
    var player = SKSpriteNode()
    
    var enemyScore = SKLabelNode()
    var playerScore = SKLabelNode()
    var stateLabel = SKLabelNode()
    
    var closeCross = SKLabelNode()
    
    var score = [PlayerRole:Int]()
    var currentGameType: gameType = .medium
    var isBallInGame = true

    var countdownTimerValue: Int = 3 {
        didSet {
            if countdownTimerValue == 4 {
                stateLabel.text = "GOAL!"
            }
            else if countdownTimerValue == 0 {
                stateLabel.text = "GO!"
            }
            else {
                stateLabel.text = "\(countdownTimerValue)"
            }
        }
    }
    override func didMove(to view: SKView) {
        self.view!.isMultipleTouchEnabled = true;
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        self.physicsBody = borderBody
        
        background = self.childNode(withName: "background") as! SKSpriteNode
        background.size = self.frame.size
        
        closeCross = self.childNode(withName: "closeCross") as! SKLabelNode
        stateLabel = self.childNode(withName: "stateLabel") as! SKLabelNode
        
        enemyScore = self.childNode(withName: "enemyScore") as! SKLabelNode
        playerScore = self.childNode(withName: "playerScore") as! SKLabelNode

        ball = self.childNode(withName: "ball") as! SKSpriteNode
        ballSprite = ball.childNode(withName: "ballSprite") as! SKSpriteNode
        ballshadow = ball.childNode(withName: "ballshadow") as! SKSpriteNode
        
        let ballBody = SKPhysicsBody(circleOfRadius: 13)
        ballBody.restitution = 1
        ballBody.friction = 0
        ballBody.linearDamping = 0
        ballBody.angularDamping = 0
        ball.physicsBody = ballBody
        ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
        ball.position = CGPoint(x: 0, y: player.position.y + 30)
        
        enemy = self.childNode(withName: "enemy") as! SKSpriteNode
        enemy.position.y = (self.frame.height / 2) - 90
        
        
        player = self.childNode(withName: "player") as! SKSpriteNode
        player.position.y = (-self.frame.height / 2) + 90
        
        let border  = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        
        self.physicsBody = border
        
        startGame()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        if closeCross.contains(touch.location(in: self)) {
            gameViewController?.performDefeat()
        }
        
        touchAction(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchAction(touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.removeAction(forKey: "playerMovement")
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        let maxY = (self.frame.height / 2) - 120
        let position = abs(ball.position.y) < 1 ? 1 : abs(ball.position.y)
        var scale = 2 - 1/maxY*position
        var shadowposition = -5 * scale * 2
        if scale < 1 {
            scale = 1
            shadowposition = -5
        }
        
        ball.run(SKAction.scale(to: scale, duration: 0))
        ballshadow.run(SKAction.move(to: CGPoint(x: shadowposition, y: shadowposition), duration: 0))
        
        
        switch currentGameType {
        case .easy:
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.2))
            break
        case .medium:
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.1))
            break
        case .hard:
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.07))
            break
        case .campaign:
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.5 / Double(((gameViewController?.currentGame?.campaignProgress)! + 1))))
            break
        case .player2:
            break
        }
    }
    
    func touchAction(_ touches: Set<UITouch>) {
        
        let playerMinY = -(self.frame.height / 2) + 80
        let playerMaxY = -(self.frame.height / 2) + 160
        
        let enemyMinY = (self.frame.height / 2) - 160
        let enemyMaxY = (self.frame.height / 2) - 80
    
        for touch in touches {
            let location = touch.location(in: self)
            
            var playerY = location.y
            if playerY < playerMinY {
                playerY = playerMinY
            }
            if playerY > playerMaxY {
                playerY = playerMaxY
            }
            
            if currentGameType == .player2 {
                if location.y > 0 {
                    
                    var enemyY = location.y
                    if enemyY < enemyMinY {
                        enemyY = enemyMinY
                    }
                    if enemyY > enemyMaxY {
                        enemyY = enemyMaxY
                    }
                    
                    enemy.run(SKAction.move(to: CGPoint(x: location.x, y: enemyY), duration: 0.1))
                }
                if location.y < 0 {
                    player.run(SKAction.move(to: CGPoint(x: location.x, y: playerY), duration: 0.1))
                }
            }
            else{
                player.run(SKAction.move(to: CGPoint(x: location.x, y: playerY), duration: 0.1))
            }
        }
    }
    
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "player" || object.name == "enemy" {
            kickBall(object)
        }
        if object.name == "Scene" {
            if ball.position.y <= player.position.y - 40 {
                addScore(playerWhoWon: .enemy)
            }
            else if ball.position.y >= enemy.position.y + 40 {
                addScore(playerWhoWon: .player)
            }
        }
    }
    
    func kickBall(_ object: SKNode) {
        if object.name == "player" {
            player.run(SKAction.sequence([
                SKAction.setTexture(SKTexture(imageNamed: "player-kick")),
                SKAction.wait(forDuration: 0.5),
                SKAction.setTexture(SKTexture(imageNamed: "player")),
                ]))
        }
        
        if object.name == "enemy" {
            enemy.run(SKAction.sequence([
                SKAction.setTexture(SKTexture(imageNamed: "enemy-kick")),
                SKAction.wait(forDuration: 0.5),
                SKAction.setTexture(SKTexture(imageNamed: "enemy")),
                ]))
        }
    }
    
    
    
    
    func startGame() {
        score = [.player: 0, .enemy: 0]
        updateScoreUI()
        startRound(isNewGame: true, .player)
    }
    
    func startRound(isNewGame: Bool, _ playerWhoWon: PlayerRole) {
        countdownTimerValue = isNewGame ? 3 : 4
        
        let wait = SKAction.wait(forDuration: 0.5)
        let block = SKAction.run({
            [unowned self] in
            
            if self.countdownTimerValue > 0{
                self.countdownTimerValue = self.countdownTimerValue - 1
            } else{
                self.stateLabel.text = ""
                self.isBallInGame = true
                self.removeAction(forKey: "countdown")
                let randomXVecotor = Int.random(in: -20...20)
                if playerWhoWon == .player {
                    self.ball.physicsBody?.applyImpulse(CGVector(dx: randomXVecotor, dy: 11))
                    self.kickBall(self.player)
                }
                else if playerWhoWon == .enemy {
                    self.ball.physicsBody?.applyImpulse(CGVector(dx: randomXVecotor, dy: -11))
                    self.kickBall(self.enemy)
                }
            }
        })
        let sequence = SKAction.sequence([wait,block])
        
        run(SKAction.repeatForever(sequence), withKey: "countdown")
    }
    
    func addScore(playerWhoWon: PlayerRole){
        isBallInGame = false
        
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        ball.run(SKAction.moveTo(x: 0, duration: 0.5))
        
        score[playerWhoWon] = score[playerWhoWon]! + 1
        
        showResultsIfGameIsDone(playerWhoWon)
        returnBallTo(playerWhoWon)
        updateScoreUI()
        startRound(isNewGame: false, playerWhoWon)
    }
    
    func showResultsIfGameIsDone(_ playerWhoWon: PlayerRole) {
        if score[playerWhoWon]! >= 10 {
            if playerWhoWon == .player {
                self.gameViewController?.performVictory()
            } else {
                self.gameViewController?.performDefeat()
            }
        }
    }
    
    func returnBallTo(_ role: PlayerRole) {
        if role == .player {
            ball.run(SKAction.move(to: CGPoint(x: 0, y: player.position.y + 30), duration: 1.3))
        } else if role == .enemy {
            ball.run(SKAction.move(to: CGPoint(x: 0, y: enemy.position.y - 30), duration: 1.3))
        }
    }
    
    func updateScoreUI() {
        enemyScore.text = String(score[.enemy]!)
        playerScore.text = String(score[.player]!)
    }
}
