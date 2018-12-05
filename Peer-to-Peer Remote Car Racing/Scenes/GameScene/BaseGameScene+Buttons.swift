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
            SKTAudio.sharedInstance().playSoundEffect("button_press.wav")
            networkService?.send(messageType: .RESUME);
            stateMachine.enter(GameActiveState.self)
        case .quit:
            SKTAudio.sharedInstance().playSoundEffect("button_press.wav")
            networkService?.send(messageType: .DISCONNECT)
            gameSceneDelegate?.quitToMenu();
        case .restart:
            SKTAudio.sharedInstance().playSoundEffect("button_press.wav")
            networkService?.send(messageType: .RESTART);
            stateMachine.enter(GameActiveState.self);
        case .selectTrack:
            SKTAudio.sharedInstance().playSoundEffect("button_press.wav")
            networkService?.send(messageType: .NAV_TRACK_SELECT);
            gameSceneDelegate?.quitToTrackSelection();
        }
    }
}
