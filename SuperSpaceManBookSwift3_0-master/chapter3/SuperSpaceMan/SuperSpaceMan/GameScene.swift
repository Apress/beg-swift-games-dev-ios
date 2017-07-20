import SpriteKit

class GameScene: SKScene {
    
    let backgroundNode = SKSpriteNode(imageNamed: "Background")
    let playerNode = SKSpriteNode(imageNamed: "Player")
    let orbNode = SKSpriteNode(imageNamed: "PowerUp")
    
    let CollisionCategoryPlayer : UInt32 = 0x1 << 1
    let CollisionCategoryPowerUpOrbs : UInt32 = 0x1 << 2

    required init?(coder aDecoder: NSCoder) {
    
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
    
        super.init(size: size)
        
        physicsWorld.contactDelegate = self
    
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0);
        
        backgroundColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    
        isUserInteractionEnabled = true
        
        // adding the background
        backgroundNode.size.width = frame.size.width
        backgroundNode.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        backgroundNode.position = CGPoint(x: size.width / 2.0, y: 0.0)
        addChild(backgroundNode)
        
        // add the player
        playerNode.position = CGPoint(x: size.width / 2.0, y: 80.0)
        
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: playerNode.size.width / 2)
        playerNode.physicsBody?.isDynamic = true
        
        playerNode.position = CGPoint(x: size.width / 2.0, y: 80.0)
        playerNode.physicsBody?.linearDamping = 1.0
        playerNode.physicsBody?.allowsRotation = false
        playerNode.physicsBody?.categoryBitMask = CollisionCategoryPlayer
        playerNode.physicsBody?.contactTestBitMask = CollisionCategoryPowerUpOrbs
        playerNode.physicsBody?.collisionBitMask = 0
        addChild(playerNode)
        
        orbNode.position = CGPoint(x: 150.0, y: size.height - 25)
        orbNode.physicsBody = SKPhysicsBody(circleOfRadius: orbNode.size.width / 2)
        orbNode.physicsBody?.isDynamic = false
        orbNode.physicsBody?.categoryBitMask = CollisionCategoryPowerUpOrbs
        orbNode.physicsBody?.collisionBitMask = 0
        orbNode.name = "POWER_UP_ORB"
        addChild(orbNode)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        playerNode.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 40.0))
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let nodeB = contact.bodyB.node
        
        if nodeB?.name == "POWER_UP_ORB" {
            
            nodeB?.removeFromParent()
        }
    }
}
