import Foundation
import SpriteKit

class SpaceMan: SKSpriteNode {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(textureAtlas: SKTextureAtlas) {
            
        let texture = textureAtlas.textureNamed("Player")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
            
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody?.isDynamic = false
        physicsBody?.linearDamping = 1.0
        physicsBody?.allowsRotation = false
            
        physicsBody?.categoryBitMask = CollisionCategoryPlayer
        physicsBody?.contactTestBitMask = CollisionCategoryPowerUpOrbs | CollisionCategoryBlackHoles
        physicsBody?.collisionBitMask = 0
    }
}
