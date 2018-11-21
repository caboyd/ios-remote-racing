//
//  GameScene.swift
//  race prototype
//
//  Created by Christopher Boyd on 2018-11-06.
//  Copyright © 2018 Christopher Boyd. All rights reserved.
//

import SpriteKit
import GameplayKit

class Track1: BaseGameScene {
    
   
    
    override func sceneDidLoad() {
        self.totalLaps = 3;
        
        super.sceneDidLoad();
    }

    override func didMove(to view: SKView) {
        super.didMove(to: view);

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event);
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        super.update(currentTime);
       
    }
    
    

}
