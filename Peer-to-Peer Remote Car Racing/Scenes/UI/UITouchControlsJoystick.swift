//
//  UITouchControlsJoystick.swift
//  Peer-to-Peer Remote Car Racing
//
//  Created by user145437 on 11/19/18.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import Foundation
import SpriteKit

class UITouchControlsJoystick : SceneRootNode {
    
    weak var gameScene:BaseGameScene!;
    
    var inputControl : InputControl!;
    
    init() {
        super.init(fileNamed: "UITouchControlsJoystick")!;
        
        let js = childNode(withName: "//joystick") as! AnalogJoystick;
        inputControl = JoystickInput(analogJoystick: js);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addDebugHUD() {
//        let pauseButton = node.childNode(withName: "//pause") as! SKSpriteNode;
//        let texture = SKTexture(imageNamed: "grey_button_up");
//        let texture2 = SKTexture(imageNamed: "grey_button_down");
//        let btn = FTButtonNode(normalTexture: texture, selectedTexture: texture2, disabledTexture: texture2);
//        btn.setButtonLabel(title: "WIN", font: "Arial", fontSize: 26);
//        btn.fontColor(color:.black);
//        btn.position = pauseButton.position;
//        btn.position.y -= btn.size.height;
//        btn.centerRect = CGRect(x: 0.49, y: 0.49, width: 0.02, height: 0.02);
//        btn.size = pauseButton.size;
//        btn.zPosition = 2;
//        btn.name = "debug_finish";
//        btn.setButtonAction(target: self.gameScene.gameSceneDelegate!, triggerEvent: .TouchUpInside, action: #selector(BaseGameSceneProtocol.presentSubmitScoreSubview(gameScene:)));
//
//        node.addChild(btn);
        
    }
    
}
