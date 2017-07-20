import SpriteKit
import CoreMotion

class GameScene: SKScene {
    
    let backgroundNode = SKSpriteNode(imageNamed: "Background")
    let playerNode = SKSpriteNode(imageNamed: "Player")
    let foregroundNode = SKSpriteNode()
    
    var impulseCount = 4
    let coreMotionManager = CMMotionManager()
    
    let CollisionCategoryPlayer      : UInt32 = 0x1 << 1
    let CollisionCategoryPowerUpOrbs : UInt32 = 0x1 << 2

    required init?(coder aDecoder: NSCoder) {
    
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
    
        super.init(size: size)
        
        physicsWorld.contactDelegate = self
    
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0);
        
        backgroundColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    
        isUserInteractionEnabled = true
        
        // adding the background
        backgroundNode.size.width = frame.size.width
        backgroundNode.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        backgroundNode.position = CGPoint(x: size.width / 2.0, y: 0.0)
        addChild(backgroundNode)
        
        addChild(foregroundNode)
        
        // add the player
        playerNode.position = CGPoint(x: size.width / 2.0, y: 80.0)
        
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: playerNode.size.width / 2)
        playerNode.physicsBody?.isDynamic = false
        
        playerNode.position = CGPoint(x: size.width / 2.0, y: 80.0)
        playerNode.physicsBody?.linearDamping = 1.0
        playerNode.physicsBody?.allowsRotation = false
        playerNode.physicsBody?.categoryBitMask = CollisionCategoryPlayer
        playerNode.physicsBody?.contactTestBitMask = CollisionCategoryPowerUpOrbs
        playerNode.physicsBody?.collisionBitMask = 0
        
        foregroundNode.addChild(playerNode)
        
        var orbNodePosition = CGPoint(x: playerNode.position.x, y: playerNode.position.y + 100)
        
        for _ in 0...19 {
            
            let orbNode = SKSpriteNode(imageNamed: "PowerUp")
                
            orbNodePosition.y += 140
            orbNode.position = orbNodePosition
            orbNode.physicsBody = SKPhysicsBody(circleOfRadius: orbNode.size.width / 2)
            orbNode.physicsBody?.isDynamic = false
                
            orbNode.physicsBody?.categoryBitMask = CollisionCategoryPowerUpOrbs
            orbNode.physicsBody?.collisionBitMask = 0
            orbNode.name = "POWER_UP_ORB"
                
            foregroundNode.addChild(orbNode)
        }
        
        orbNodePosition = CGPoint(x: playerNode.position.x + 50, y: orbNodePosition.y)
        
        for _ in 0...19 {
            
            let orbNode = SKSpriteNode(imageNamed: "PowerUp")
            
            orbNodePosition.y += 140
            orbNode.position = orbNodePosition
            orbNode.physicsBody = SKPhysicsBody(circleOfRadius: orbNode.size.width / 2)
            orbNode.physicsBody?.isDynamic = false
    
            orbNode.physicsBody?.categoryBitMask = CollisionCategoryPowerUpOrbs
            orbNode.physicsBody?.collisionBitMask = 0
            orbNode.name = "POWER_UP_ORB"
            
            foregroundNode.addChild(orbNode)
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
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if playerNode.position.y >= 180.0 {
            
            backgroundNode.position = CGPoint(x: backgroundNode.position.x, y: -((playerNode.position.y - 180.0)/8))
            foregroundNode.position = CGPoint(x: foregroundNode.position.x, y: -(playerNode.position.y - 180.0))
        }
    }
    
    override func didSimulatePhysics() {
        
        if let accelerometerData = coreMotionManager.accelerometerData {
            
            playerNode.physicsBody!.velocity =
                CGVector(dx: CGFloat(accelerometerData.acceleration.x * 380.0),
                         dy: playerNode.physicsBody!.velocity.dy)
        }
        
        if playerNode.position.x < -(playerNode.size.width / 2) {
            
            playerNode.position = CGPoint(x: size.width - playerNode.size.width / 2, y: playerNode.position.y);
        }
        else if playerNode.position.x > size.width {
            
            playerNode.position = CGPoint(x: playerNode.size.width / 2, y: playerNode.position.y);
        }
    }
    
    deinit {
        
        coreMotionManager.stopAccelerometerUpdates()
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let nodeB = contact.bodyB.node!
        
        if nodeB.name == "POWER_UP_ORB"  {
            
            impulseCount += 1
            nodeB.removeFromParent()
        }
    }
}
