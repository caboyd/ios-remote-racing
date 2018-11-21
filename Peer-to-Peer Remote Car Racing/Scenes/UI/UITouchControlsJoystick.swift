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
    
  
    var inputControl : InputControl!;
    var pauseButton: FTButtonNode!;
    var top: SKNode!;
    
    init() {
        super.init(fileNamed: "UITouchControlsJoystick")!;
        
        let js = childNode(withName: ".//joystick") as! AnalogJoystick;
        inputControl = JoystickInput(analogJoystick: js);
        
        top = childNode(withName: ".//top")!;
        let pause = childNode(withName: ".//pause") as! SKSpriteNode;
        pause.removeFromParent();
        pauseButton = FTButtonNode(normalTexture: pause.texture, selectedTexture: pause.texture, disabledTexture: pause.texture);
        pauseButton.position = pause.position;
        top.addChild(pauseButton);
     
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addDebugHUD(gameScene: BaseGameScene) {
        let t = SKTexture(imageNamed: "blackButton");
        let t2 = SKTexture(imageNamed: "blackButtonHighlighted")
        let btn = FTButtonNode(normalTexture: t, selectedTexture: t2, disabledTexture: t);
        btn.setButtonLabel(title: "WIN", font: "Arial", fontSize: 26);
        btn.fontColor(color:.black);
        btn.position = pauseButton.position;
        btn.position.y -= btn.size.height;
        btn.centerRect = CGRect(x: 0.49, y: 0.49, width: 0.02, height: 0.02);
        btn.size = pauseButton.size;
        btn.label.zPosition = 1;
        btn.name = "debug_finish";
        btn.setButtonAction(target: gameScene, triggerEvent: .TouchUpInside, action: #selector(BaseGameScene.win));
        top.addChild(btn);
        
    }
    
}
