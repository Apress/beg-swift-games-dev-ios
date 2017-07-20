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
    var sceneView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        mainScene = createMainScene()
        
        createMainCamera()
        
        sceneView = self.view as! SCNView
        sceneView.scene = mainScene
        
        // Optional, but nice to be turned on during developement
        sceneView.showsStatistics = true
        sceneView.allowsCameraControl = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        gesture.numberOfTapsRequired = 2
        sceneView.addGestureRecognizer(gesture)
        
    }
    
    func handleTapGesture(recognizer: UIGestureRecognizer) {

        createHeroCamera()

        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.75
        sceneView.pointOfView = mainScene.rootNode.childNode(withName: "hero", recursively: true)
        SCNTransaction.commit()
    }
    
    
    func createMainScene() -> SCNScene {
        
        let mainScene = SCNScene(named: "art.scnassets/hero.dae")
        mainScene?.rootNode.addChildNode(createFloorNode())
        mainScene?.rootNode.addChildNode(Collectable.pyramidNode())
        mainScene?.rootNode.addChildNode(Collectable.sphereNode())
        mainScene?.rootNode.addChildNode(Collectable.boxNode())
        mainScene?.rootNode.addChildNode(Collectable.tubeNode())
        mainScene?.rootNode.addChildNode(Collectable.cylinderNode())
        mainScene?.rootNode.addChildNode(Collectable.torusNode())
        
        return mainScene!
    }
    
    func createFloorNode() -> SCNNode {

        let floorNode = SCNNode()
        floorNode.geometry = SCNFloor()
        floorNode.geometry?.firstMaterial?.diffuse.contents = "floor"
        
        return floorNode
    }

    func createHeroCamera() {
        
        let cameraNode = mainScene.rootNode.childNode(withName: "mainCamera", recursively: true)
        
        cameraNode?.camera?.zFar = 1000
        cameraNode?.position = SCNVector3(x: 0, y: 0, z: -100)
        
//        cameraNode?.camera?.usesOrthographicProjection = true
//        cameraNode?.camera?.orthographicScale = 100
        cameraNode?.eulerAngles = SCNVector3(x: 0, y: 90, z: 0) //Float(-M_PI_4*0.75))
        
        let heroNode = mainScene.rootNode.childNode(withName: "hero", recursively: true)
        heroNode?.addChildNode(cameraNode!)

        mainScene.rootNode.childNode(withName: "hero", recursively: true)?.addChildNode(cameraNode!)
    }
    
    func createMainCamera() {
        
        let cameraNode = SCNNode()
        cameraNode.name = "mainCamera"
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.zFar = 1000
        cameraNode.position = SCNVector3(x: 0, y: 15, z: 10)
        cameraNode.rotation = SCNVector4(x: 0, y: 0, z: 0, w: -Float.pi/4 * 0.5) //Float(-M_PI_4*0.75))
        
        let heroNode = mainScene.rootNode.childNode(withName: "hero", recursively: true)
        heroNode?.addChildNode(cameraNode)
        
//        mainScene.rootNode.addChildNode(cameraNode)
    }
    
}
