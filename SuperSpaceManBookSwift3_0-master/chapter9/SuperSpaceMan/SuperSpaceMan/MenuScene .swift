import SpriteKit

class MenuScene: SKScene {
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    init(size: CGSize, gameResult: Bool, score: Int) {
        
        super.init(size: size)
        
        let backgroundNode = SKSpriteNode(imageNamed: "Background")
        backgroundNode.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        backgroundNode.size.width = self.frame.size.width 
        backgroundNode.position = CGPoint(x:size.width / 2.0, y: 0.0)
        addChild(backgroundNode)
        
        let gameResultTextNode = SKLabelNode(fontNamed: "Copperplate")
        gameResultTextNode.text = "YOU " + (gameResult ? "WON" : "LOST")
        gameResultTextNode.horizontalAlignmentMode =
            SKLabelHorizontalAlignmentMode.center
        gameResultTextNode.verticalAlignmentMode =
            SKLabelVerticalAlignmentMode.center
        gameResultTextNode.fontSize = 20
        gameResultTextNode.fontColor = SKColor.white
        gameResultTextNode.position =
            CGPoint(x: size.width / 2.0, y: size.height - 200.0)
        addChild(gameResultTextNode)
        
        let scoreTextNode = SKLabelNode(fontNamed: "Copperplate")
        scoreTextNode.text = "SCORE :  \(score)"
        scoreTextNode.horizontalAlignmentMode =
            SKLabelHorizontalAlignmentMode.center
        scoreTextNode.verticalAlignmentMode =
            SKLabelVerticalAlignmentMode.center
        scoreTextNode.fontSize = 20
        scoreTextNode.fontColor = SKColor.white
        scoreTextNode.position = CGPoint(x: size.width / 2.0,
            y: gameResultTextNode.position.y - 40.0)
        addChild(scoreTextNode)
        
        let tryAgainTextNodeLine1 = SKLabelNode(fontNamed: "Copperplate")
        tryAgainTextNodeLine1.text = "TAP ANYWHERE"
        tryAgainTextNodeLine1.horizontalAlignmentMode =
            SKLabelHorizontalAlignmentMode.center
        tryAgainTextNodeLine1.verticalAlignmentMode =
            SKLabelVerticalAlignmentMode.center
        tryAgainTextNodeLine1.fontSize = 20
        tryAgainTextNodeLine1.fontColor = SKColor.white
        tryAgainTextNodeLine1.position = CGPoint(x: size.width / 2.0, y: 100.0)
        addChild(tryAgainTextNodeLine1)
        
        let tryAgainTextNodeLine2 = SKLabelNode(fontNamed: "Copperplate")
        tryAgainTextNodeLine2.text = "TO PLAY AGAIN!"
        tryAgainTextNodeLine2.horizontalAlignmentMode =
            SKLabelHorizontalAlignmentMode.center
        tryAgainTextNodeLine2.verticalAlignmentMode =
            SKLabelVerticalAlignmentMode.center
        tryAgainTextNodeLine2.fontSize = 20
        tryAgainTextNodeLine2.fontColor = SKColor.white
        tryAgainTextNodeLine2.position = CGPoint(x: size.width / 2.0,
            y: tryAgainTextNodeLine1.position.y - 40.0)
        addChild(tryAgainTextNodeLine2)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let transition = SKTransition.doorsOpenHorizontal(withDuration: 2.0)
        let gameScene = GameScene(size: size)
        
        view?.presentScene(gameScene, transition: transition)
    }
}
