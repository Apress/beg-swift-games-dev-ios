import SpriteKit

class GameViewController: UIViewController {
    
    var scene: GameScene!
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 1. Configure the main view
        let skView = view as! SKView
        skView.showsFPS = true
        
        // 2. Create and configure our game scene
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        // 3. Show the scene.
        skView.presentScene(scene)
    }
}
