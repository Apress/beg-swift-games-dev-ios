import SpriteKit
import CoreMotion

class GameScene: SKScene {
    
    var backgroundNode = SKSpriteNode(imageNamed: "Background")
    var backgroundStarsNode = SKSpriteNode(imageNamed: "Stars")
    var backgroundPlanetNode = SKSpriteNode(imageNamed: "PlanetStart")
    var foregroundNode = SKSpriteNode()
    var playerNode: SKSpriteNode!
    
    var impulseCount = 4
    let coreMotionManager = CMMotionManager()
    
    var engineExhaust : SKEmitterNode?
    
    var score = 0
    let scoreTextNode = SKLabelNode(fontNamed: "Copperplate")
    let impulseTextNode = SKLabelNode(fontNamed: "Copperplate")
    
    let orbPopAction = SKAction.playSoundFileNamed("orb_pop.wav", waitForCompletion: false)
    
    let startGameTextNode = SKLabelNode(fontNamed: "Copperplate")
    
    required init?(coder aDecoder: NSCoder) {
    
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
    
        super.init(size: size)
        let textureAtlas = SKTextureAtlas(named: "sprites.atlas")

        physicsWorld.contactDelegate = self
    
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0);
        
        backgroundColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    
        isUserInteractionEnabled = true
        
        // adding the background
        backgroundNode.size.width = frame.size.width
        backgroundNode.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        backgroundNode.position = CGPoint(x: size.width / 2.0, y: 0.0)
        addChild(backgroundNode)
        
        backgroundStarsNode.size.width = frame.size.width
        backgroundStarsNode.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        backgroundStarsNode.position = CGPoint(x: size.width / 2.0, y: 0.0)
        addChild(backgroundStarsNode)
        
        backgroundPlanetNode.size.width = frame.size.width
        backgroundPlanetNode.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        backgroundPlanetNode.position = CGPoint(x: size.width / 2.0, y: 0.0)
        addChild(backgroundPlanetNode)
        
        addChild(foregroundNode)
        
        // add the player
        playerNode = SpaceMan(textureAtlas: textureAtlas)
        playerNode.position = CGPoint(x: size.width / 2.0, y: 220.0)
        
        foregroundNode.addChild(playerNode)
        
        addBlackHolesToForeground()
        addOrbsToForeground()
        
        let engineExhaustPath = Bundle.main.path(forResource: "EngineExhaust", ofType: "sks")
        engineExhaust = NSKeyedUnarchiver.unarchiveObject(withFile: engineExhaustPath!) as? SKEmitterNode
        engineExhaust?.position = CGPoint(x: 0.0, y: -(playerNode.size.height / 2))
        engineExhaust?.isHidden = true

        playerNode.addChild(engineExhaust!)
        
        scoreTextNode.text = "SCORE : \(score)"
        scoreTextNode.fontSize = 20
        scoreTextNode.fontColor = SKColor.white
        scoreTextNode.position = CGPoint(x: size.width - 10, y: size.height - 20)
        scoreTextNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        
        addChild(scoreTextNode)
        
        impulseTextNode.text = "IMPULSES : \(impulseCount)"
        impulseTextNode.fontSize = 20
        impulseTextNode.fontColor = SKColor.white
        impulseTextNode.position = CGPoint(x: 10.0, y: size.height - 20)
        impulseTextNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        
        addChild(impulseTextNode)
        
        startGameTextNode.text = "TAP ANYWHERE TO START!"
        startGameTextNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        startGameTextNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        startGameTextNode.fontSize = 20
        startGameTextNode.fontColor = SKColor.white
        startGameTextNode.position = CGPoint(x: scene!.size.width / 2, y: scene!.size.height / 2)
        
        addChild(startGameTextNode)
    }
    
    func addOrbsToForeground() {
        
        let orbPlistPath = Bundle.main.path(forResource: "orbs", ofType: "plist")
        let orbDataDictionary = NSDictionary(contentsOfFile: orbPlistPath!)
        
        if let positionDictionary = orbDataDictionary {
            
            let positions = positionDictionary.object(forKey: "positions") as! NSArray
            
            for position in positions {
                
                let orbNode = Orb(textureAtlas: SKTextureAtlas(named: "sprites.atlas"))
                let x = (position as AnyObject).object(forKey: "x") as! CGFloat
                let y = (position as AnyObject).object(forKey: "y") as! CGFloat
                orbNode.position = CGPoint(x: x, y: y)
                foregroundNode.addChild(orbNode)
            }
        }
    }
    
    func addBlackHolesToForeground() {
        
        let moveLeftAction = SKAction.moveTo(x: 0.0, duration: 2.0)
        let moveRightAction = SKAction.moveTo(x: size.width, duration: 2.0)
        let actionSequence = SKAction.sequence([moveLeftAction, moveRightAction])
        let moveAction = SKAction.repeatForever(actionSequence)
        
        let blackHolePlistPath = Bundle.main.path(forResource: "blackholes", ofType: "plist")
        let blackHoleDataDictionary = NSDictionary(contentsOfFile: blackHolePlistPath!)
        
        if let positionDictionary = blackHoleDataDictionary {
            
            let positions = positionDictionary.object(forKey: "positions") as! NSArray
            
            for position in positions {
                
                let blackHoleNode = BlackHole(textureAtlas: SKTextureAtlas(named: "sprites.atlas"))
                
                let x = (position as AnyObject).object(forKey: "x") as! CGFloat
                let y = (position as AnyObject).object(forKey: "y")as! CGFloat
                blackHoleNode.position = CGPoint(x: x, y: y)
                
                blackHoleNode.run(moveAction)
                
                foregroundNode.addChild(blackHoleNode)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !playerNode.physicsBody!.isDynamic {
            
            playerNode.physicsBody?.isDynamic = true
            coreMotionManager.accelerometerUpdateInterval = 0.3
            coreMotionManager.startAccelerometerUpdates()
        }
        
        if impulseCount > 0 {
            
            playerNode.physicsBody!.applyImpulse(CGVector(dx: 0.0, dy: 40.0))
            
            impulseCount -= 1
            impulseTextNode.text = "IMPULSES : \(impulseCount)"
            
            engineExhaust!.isHidden = false
            
            Timer.scheduledTimer(timeInterval: 0.5,
                                 target: self,
                                 selector: #selector(GameScene.hideEngineExaust(_:)),
                                 userInfo: nil,
                                 repeats: false)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if playerNode.position.y >= 180.0 &&
            playerNode.position.y < 6400.0 {
            
            backgroundNode.position = CGPoint(x: backgroundNode.position.x, y: -((playerNode.position.y - 180.0)/8));
            
            backgroundStarsNode.position = CGPoint(x: backgroundStarsNode.position.x, y: -((playerNode.position.y - 180.0)/6));
            
            backgroundPlanetNode.position = CGPoint(x: self.backgroundPlanetNode.position.x, y: -((playerNode.position.y - 180.0)/8));
            
            foregroundNode.position = CGPoint(x: foregroundNode.position.x, y: -(playerNode.position.y - 180.0));
        }
        else if playerNode.position.y > 7000.0 {
            
            gameOverWithResult(true)
        }
        else if playerNode.position.y + playerNode.size.height < 0.0 {
            
            gameOverWithResult(false)
        }
        
        removeOutOfSceneNodesWithName("BLACK_HOLE")
        removeOutOfSceneNodesWithName("POWER_UP_ORB")
    }
    
    func removeOutOfSceneNodesWithName(_ name: String) {
        
        foregroundNode.enumerateChildNodes(withName: name, using: {
            node, stop in

            if self.playerNode.position.y - node.position.y > self.size.height {
                
                node.removeFromParent()
            }
        })
    }
    
    func gameOverWithResult(_ gameResult: Bool) {
        
        playerNode.removeFromParent()
        
        let transition = SKTransition.crossFade(withDuration: 2.0)
        let menuScene = MenuScene(size: size, gameResult: gameResult, score: score)
        
        view?.presentScene(menuScene, transition: transition)
    }
    
    override func didSimulatePhysics() {
        
        if let accelerometerData = coreMotionManager.accelerometerData {
            
            playerNode.physicsBody!.velocity =
                CGVector(dx: CGFloat(accelerometerData.acceleration.x * 380.0),
                         dy: playerNode.physicsBody!.velocity.dy)
        }
        
        if playerNode.position.x < -(playerNode.size.width / 2) {
            
            playerNode.position = CGPoint(x: size.width - playerNode.size.width / 2, y: playerNode.position.y)
        }
        else if playerNode.position.x > size.width {
            
            playerNode.position = CGPoint(x: playerNode.size.width / 2, y: playerNode.position.y)
        }
    }
    
    func hideEngineExaust(_ timer:Timer!) {
        
        if !engineExhaust!.isHidden {
            
            engineExhaust!.isHidden = true
        }
    }
    
    deinit {
        
        self.coreMotionManager.stopAccelerometerUpdates()
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let nodeB = contact.bodyB.node!
        
        if nodeB.name == "POWER_UP_ORB"  {
            
            self.run(orbPopAction)
            
            self.impulseCount += 1
            self.impulseTextNode.text = "IMPULSES : \(self.impulseCount)"
            
            self.score += 1
            self.scoreTextNode.text = "SCORE : \(self.score)"
            
            nodeB.removeFromParent()
        }
        else if nodeB.name == "BLACK_HOLE"  {
            
            playerNode.physicsBody!.contactTestBitMask = 0
            impulseCount = 0
            
            let colorizeAction = SKAction.colorize(with: UIColor.red,
                                                   colorBlendFactor: 1.0, duration: 1)
            playerNode.run(colorizeAction)
        }
    }
}



