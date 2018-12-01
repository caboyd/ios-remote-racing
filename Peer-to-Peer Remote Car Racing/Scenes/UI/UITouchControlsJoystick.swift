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
    
    var gasButton: FTButtonNode!;
    var reverseButton : FTButtonNode!;
    var buttons: SKNode!;
    
    init(gameScene: BaseGameScene, buttonsEnabled: Bool) {
        super.init(fileNamed: "UITouchControlsJoystick")!;
        
        let js = childNode(withName: ".//joystick") as! AnalogJoystick;
        
        
        top = childNode(withName: ".//top")!;
        let pause = childNode(withName: ".//pause") as! SKSpriteNode;
        pause.removeFromParent();
        pauseButton = FTButtonNode(normalTexture: pause.texture, selectedTexture: pause.texture, disabledTexture: pause.texture);
        pauseButton.position = pause.position;
        pauseButton.setButtonAction(target: gameScene, triggerEvent: .TouchUpInside, action: #selector(BaseGameScene.pause));
        top.addChild(pauseButton);
        
        buttons = childNode(withName: ".//buttons")!;
        
        if buttonsEnabled {
            setupGasReverseButtons();
            inputControl = JoystickButtonInput(analogJoystick: js);
        } else {
            inputControl = JoystickInput(analogJoystick: js);
            buttons.isHidden = true;
        }

     
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupGasReverseButtons() {
        //Setup Gas Button Node
        let gas = buttons.childNode(withName: ".//gas") as! SKSpriteNode;
        gas.removeFromParent();
        gasButton = FTButtonNode(normalTexture: gas.texture, selectedTexture: gas.texture, disabledTexture: gas.texture);
        gasButton.position = gas.position;
        gasButton.xScale = gas.xScale;
        gasButton.yScale = gas.yScale;
        gasButton.setButtonAction(target: self, triggerEvent: .TouchDown, action: #selector(UITouchControlsJoystick.gasDown));
        gasButton.setButtonAction(target: self, triggerEvent: .TouchUp, action: #selector(UITouchControlsJoystick.gasUp))
        buttons.addChild(gasButton);
        
        //Setup Reverse Button Node
        let reverse = buttons.childNode(withName: ".//reverse") as! SKSpriteNode;
        reverse.removeFromParent();
        reverseButton = FTButtonNode(normalTexture: reverse.texture, selectedTexture: reverse.texture, disabledTexture: reverse.texture);
        reverseButton.position = reverse.position;
        reverseButton.xScale = reverse.xScale;
        reverseButton.yScale = reverse.yScale;
        reverseButton.setButtonAction(target: self, triggerEvent: .TouchDown, action: #selector(UITouchControlsJoystick.reverseDown));
        
        reverseButton.setButtonAction(target: self, triggerEvent: .TouchUp, action: #selector(UITouchControlsJoystick.reverseUp))
        buttons.addChild(reverseButton);
        
        
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
 
    @objc func gasDown() {
        inputControl.velocity.y = 1.0;
    }
    
    @objc func gasUp() {
        inputControl.velocity.y = 0.0;
    }
    
    @objc func reverseDown(){
        inputControl.velocity.y = -1.0;
    }
    
    @objc func reverseUp() {
        inputControl.velocity.y = 0.0;
    }
}
