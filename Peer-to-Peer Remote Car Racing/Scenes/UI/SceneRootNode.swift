//
//  SceneRootNode.swift
//  Peer-to-Peer Remote Car Racing
//
//  Created by user145437 on 11/20/18.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import Foundation
import SpriteKit

//Helper class to load the UI sks files so they can be easily resized
class SceneRootNode : SKNode {
    
    var originalSize : CGSize!;
    var top : SKNode!;
    var bottom : SKNode!;
    
    init?(fileNamed fileName: String) {
        super.init();
        guard let scene = SKScene.init(fileNamed: fileName) else {
            fatalError("Scene \(fileName) not found");
        }
       
        //Find the root note and original size of the sks file
        if let root = scene.childNode(withName: "root") {
            self.originalSize = scene.size;
            root.removeFromParent()
            self.addChild(root);
            self.top = root.childNode(withName: ".//top")!;
            self.bottom = root.childNode(withName: ".//bottom")!;
        } else {
            fatalError("Scene \(fileName) missing root node");
        }
        
        //Resize the sks file to fit the screen
        resizeToDisplay();
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func resizeToDisplay() {
        //Fixes HUD for different resolution displays
        let scale = displaySize.width / originalSize.width;
        self.setScale(scale);
        
        //Moves the HUD to the top of the screen for different aspect ratios
        top.position.y = (displaySize.height / 2) / scale;
        bottom.position.y = (-displaySize.height / 2 ) / scale;
    }
}
