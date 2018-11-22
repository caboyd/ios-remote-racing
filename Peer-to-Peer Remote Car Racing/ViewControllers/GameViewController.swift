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
    var scene : BaseGameScene?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = BaseGameScene(fileNamed: self.track) {
            self.scene = scene;
            // Copy gameplay related content over to the scene
            scene.joystickEnabled = true;
            scene.debugMode = true;
            scene.gameSceneDelegate = self;
            
            // Set the scale mode to scale to fit the window
            //scene.scaleMode = .aspectFill
            //scene.size = scene.trackSize;
            
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            self.scene?.resize();
        }
    }
}


extension GameViewController: BaseGameSceneProtocol {
    @objc func presentSubmitScoreSubview(gameScene: BaseGameScene) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "SubmitScoreViewController") as! SubmitScoreViewController;
        
        controller.time = gameScene.totalTime;
        
        self.addChild(controller);
        view.addSubview(controller.view);
        controller.didMove(toParent: self);
    }
    
    func quitToMenu() {
        _ = navigationController?.popToRootViewController(animated: false)
        //TODO: Close network session
        // send message to close
    }
    
    func quitToTrackSelection() {
        _ = navigationController?.popViewController(animated: true)
    }
}

