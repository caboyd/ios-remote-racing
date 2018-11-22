//
//  BaseGameScene+Buttons.swift
//  Peer-to-Peer Remote Car Racing
//
//  Created by user145437 on 11/18/18.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import Foundation

extension BaseGameScene : ButtonNodeResponder {
    
    func findAllButtonsInScene() -> [ButtonNode] {
        return ButtonIdentifier.allIdentifiers.compactMap { buttonIdentifier in
            return childNode(withName: "//\(buttonIdentifier.rawValue)") as? ButtonNode
        }
    }
    
    func buttonPressed(button: ButtonNode) {
        SKTAudio.sharedInstance().playSoundEffect("button_press.wav");
        
        switch button.buttonIdentifier! {
        case .resume:
            stateMachine.enter(GameActiveState.self)
        case .quit:
            gameSceneDelegate?.quitToMenu();
        case .restart:
            stateMachine.enter(GameActiveState.self);
        case .pause:
            stateMachine.enter(GamePauseState.self);
        case .selectTrack:
            gameSceneDelegate?.quitToTrackSelection();
        }
    }
}
