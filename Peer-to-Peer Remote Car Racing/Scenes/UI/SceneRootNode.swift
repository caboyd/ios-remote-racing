//
//  SceneRootNode.swift
//  Peer-to-Peer Remote Car Racing
//
//  Created by user145437 on 11/20/18.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import Foundation
import SpriteKit


class SceneRootNode : SKNode {
    
    var originalSize : CGSize!;
    
    init?(fileNamed fileName: String) {
        super.init();
        guard let scene = SKScene.init(fileNamed: fileName) else {
            fatalError("Scene \(fileName) not found");
        }
       
        if let root = scene.childNode(withName: "root") {
            self.originalSize = scene.size;
            root.removeFromParent()
            self.addChild(root);
        } else {
            fatalError("Scene \(fileName) missing root node");
        }
        
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
        self.childNode(withName: ".//top")?.position.y = (displaySize.height / 2) / scale;
        self.childNode(withName: ".//bottom")?.position.y = (-displaySize.height / 2 ) / scale;
    }
}
