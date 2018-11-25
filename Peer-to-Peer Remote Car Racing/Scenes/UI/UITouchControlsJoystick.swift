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
    
    weak var gameScene : BaseGameScene?;
    var inputControl : InputControl!;
    var pauseButton: FTButtonNode!;
    var top: SKNode!;
    
    init(gameScene: BaseGameScene) {
        super.init(fileNamed: "UITouchControlsJoystick")!;
        
        let js = childNode(withName: ".//joystick") as! AnalogJoystick;
        inputControl = JoystickInput(analogJoystick: js);
        
        top = childNode(withName: ".//top")!;
        let pause = childNode(withName: ".//pause") as! SKSpriteNode;
        pause.removeFromParent();
        pauseButton = FTButtonNode(normalTexture: pause.texture, selectedTexture: pause.texture, disabledTexture: pause.texture);
        pauseButton.position = pause.position;
        pauseButton.setButtonAction(target: gameScene, triggerEvent: .TouchUpInside, action: #selector(BaseGameScene.pause));
        top.addChild(pauseButton);
     
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addDebugHUD(gameScene: BaseGameScene) {
        let t = SKTexture(imageNamed: "blackButton");
        let t2 = SKTexture(imageNamed: "blackButtonHighlight")
        let btn = FTButtonNode(normalTexture: t, selectedTexture: t2, disabledTexture: t);
        btn.setButtonLabel(title: "WIN", font: "Arial", fontSize: 22);
        btn.fontColor(color:.white);
        btn.position = pauseButton.position;
        btn.centerRect = CGRect(x: 0.49, y: 0.49, width: 0.02, height: 0.02);
        btn.size = pauseButton.size;
        btn.position.x -= btn.size.width * 1.01;
        btn.label.zPosition = 1;
        btn.name = "debug_finish";
        btn.setButtonAction(target: gameScene, triggerEvent: .TouchUpInside, action: #selector(BaseGameScene.debugWin));
        top.addChild(btn);
        
    }
    
}
