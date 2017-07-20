//
//  GameViewController.swift
//  Swifystein3D
//
//  Created by Wesley Matlock on 7/22/16.
//  Copyright © 2016 Apress. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    var mainScene: SCNScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        mainScene = createMainScene()
        let sceneView = self.view as! SCNView
        sceneView.scene = mainScene
        
        // Optional, but nice to be turned on during developement
        sceneView.showsStatistics = true
        sceneView.allowsCameraControl = true
        
    }

    func createMainScene() -> SCNScene {
        
        let mainScene = SCNScene(named: "art.scnassets/hero.dae")
        mainScene?.rootNode.addChildNode(createFloorNode())
        return mainScene!
    }
    
    func createFloorNode() -> SCNNode {

        let floorNode = SCNNode()
        floorNode.geometry = SCNFloor()
        floorNode.geometry?.firstMaterial?.diffuse.contents = "Floor"
        
        return floorNode
    }

}
