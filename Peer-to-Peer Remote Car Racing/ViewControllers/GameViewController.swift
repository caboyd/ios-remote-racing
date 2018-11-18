//
//  GameViewController.swift
//  race prototype
//
//  Created by Christopher Boyd on 2018-11-06.
//  Copyright © 2018 Christopher Boyd. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var carType:String = "";
    var track:String = "Track1";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = BaseTrack(fileNamed: self.track) {
            
            // Copy gameplay related content over to the scene
            scene.joystickEnabled = true;
            
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            if let view = self.view as! SKView? {
                view.presentScene(scene)
                
                view.ignoresSiblingOrder = true
                
                view.showsFPS = true
                view.showsNodeCount = true
                //view.showsPhysics = true;
            }
            
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
