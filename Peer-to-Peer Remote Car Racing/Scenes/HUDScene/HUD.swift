//
//  HUDNode.swift
//  Peer-to-Peer Remote Car Racing
//
//  Created by user145437 on 11/19/18.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import Foundation
import SpriteKit

class HUD  {
    
    weak var gameScene:BaseGameScene!;
    
    var node: SKNode;
    var lapLabel:SKLabelNode!;
    var timeLabel:SKLabelNode!;
    var bestLapTimeLabel:SKLabelNode!;
    var bestLapNode:SKNode!;
    
    init(gameScene:BaseGameScene ,debugMode: Bool = false) {
        self.gameScene = gameScene;
        let HUDScene = SKScene(fileNamed: "HUD");
        node = HUDScene?.childNode(withName: "HUD")!.copy() as! SKNode;
        lapLabel = (node.childNode(withName: "//lapLabel") as! SKLabelNode);
        timeLabel = (node.childNode(withName: "//timeLabel") as! SKLabelNode);
        bestLapNode = (node.childNode(withName: "//BestLap"));
        bestLapTimeLabel = (node.childNode(withName: "//bestLapLabel") as! SKLabelNode);
        bestLapNode.isHidden = true;
        
        //Fixes HUD for different resolution displays
        let HUDAspect = (HUDScene?.frame.size.width)! / (HUDScene?.frame.size.height)!;
        let maxAspect = displayAspect / HUDAspect;
        let scale = displaySize.height / (HUDScene?.frame.size.height)! * maxAspect
        node.setScale( scale);
        
        //Moves the HUD to the top of the screen for different aspect ratios
        node.position.y += (displaySize.height - (HUDScene?.frame.size.height)! * scale) / 2;
        
        if debugMode {
            addDebugHUD();
        }
        
        ButtonNode.parseButtonInNode(containerNode: node);
    }
    
    func addDebugHUD() {
        let pauseButton = node.childNode(withName: "//pause") as! SKSpriteNode;
        let texture = SKTexture(imageNamed: "grey_button_up");
        let texture2 = SKTexture(imageNamed: "grey_button_down");
        let btn = FTButtonNode(normalTexture: texture, selectedTexture: texture2, disabledTexture: texture2);
        btn.setButtonLabel(title: "WIN", font: "Arial", fontSize: 26);
        btn.fontColor(color:.black);
        btn.position = pauseButton.position;
        btn.position.y -= btn.size.height;
        btn.centerRect = CGRect(x: 0.49, y: 0.49, width: 0.02, height: 0.02);
        btn.size = pauseButton.size;
        btn.zPosition = 2;
        btn.name = "debug_finish";
        btn.setButtonAction(target: self.gameScene.gameSceneDelegate!, triggerEvent: .TouchUpInside, action: #selector(BaseGameSceneProtocol.presentSubmitScoreSubview(gameScene:)));
        
        node.addChild(btn);
        
    }
    
}
