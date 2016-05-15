//
//  GameViewController.swift
//  POC-SceneKit
//
//  Created by Etienne De Ladonchamps on 15/02/2016.
//  Copyright (c) 2016 Etienne De Ladonchamps. All rights reserved.
//

import UIKit
import SceneKit

class PlantSceneViewController: UIViewController, SCNSceneRendererDelegate {
    
    var animProgress: Float = 0
    var morpher: SCNMorpher?
    var scnView: SCNView?
    var lastUpdateTimeInterval: NSTimeInterval = 0
    var currentCameraRotationVert: Float = 0
    var currentCameraRotationHor: Float = 0
    let cameraContainerNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // retrieve the SCNView
        let scnView = self.view as! SCNView
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        scnView.backgroundColor = UIColor(red: 0.8, green: 0.9, blue: 0.98, alpha: 1)
        scnView.delegate = self
        
        // create a new scene
        let scene = SCNScene()
        // set the scene to the view
        scnView.scene = scene
        
        let startTime = CFAbsoluteTimeGetCurrent()

        let plant = SYElementBranch()
        scene.rootNode.addChildNode(plant)
        
        // Async task
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            plant.render(1.6)
        }
        
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        print("Render time : \(timeElapsed)")

        let cameraTarget = SCNNode()
        cameraTarget.position = SCNVector3Make(0, 0.5, 0)
        scene.rootNode.addChildNode(cameraTarget)
        
        // create and add a camera to the scene
        scene.rootNode.addChildNode(cameraContainerNode)
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.xFov = 30.0
        cameraNode.position = SCNVector3Make(0, 1.5, 5)
        cameraContainerNode.addChildNode(cameraNode)
        cameraContainerNode.position = SCNVector3Make(0, 0, 0)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor.darkGrayColor()
        scene.rootNode.addChildNode(ambientLightNode)

        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLightTypeOmni
        lightNode.position = SCNVector3Make(2, 3, 0)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add a light to the scene
        let lightNode2 = SCNNode()
        lightNode2.light = SCNLight()
        lightNode2.light!.type = SCNLightTypeOmni
        lightNode2.position = SCNVector3Make(2, 2, 2);
        scene.rootNode.addChildNode(lightNode2)
        
        // Add froor
//        let floorMat = SCNMaterial()
//        floorMat.diffuse.contents = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
//        floorMat.doubleSided = true
//        floorMat.transparent.contents = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
//        let myFloor = SCNFloor()
//        myFloor.materials = [floorMat]
//        myFloor.reflectivity = 0;
//        let myFloorNode = SCNNode(geometry: myFloor)
//        myFloorNode.position = SCNVector3Make(0, 0, 0);
//        scene.rootNode.addChildNode(myFloorNode)

    }
    
    @IBAction func onPlantPan(gestureRecognize: UIPanGestureRecognizer) {
        let translation = gestureRecognize.translationInView(self.view)
        
        let horRotate = (self.currentCameraRotationHor - Float(translation.x)/80) % (Float(M_PI) * 2)
        var vertRotate = self.currentCameraRotationVert - Float(translation.y)/100
        vertRotate = max(vertRotate, -1)
        vertRotate = min(vertRotate, 0.2)
        
        let horRotateVect  = GLKMatrix4MakeRotation(horRotate, 0, 1, 0)
        let vertRotateVect = GLKMatrix4MakeRotation(vertRotate, 1, 0, 0)
        
        let result = GLKMatrix4Multiply(horRotateVect, vertRotateVect)
        
        let resultQuat = GLKQuaternionMakeWithMatrix4(result)
        
        cameraContainerNode.orientation = SCNVector4Make(resultQuat.x, resultQuat.y, resultQuat.z, resultQuat.w)
        
        if(gestureRecognize.state == UIGestureRecognizerState.Ended) {
            currentCameraRotationHor = horRotate
            currentCameraRotationVert = vertRotate
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}