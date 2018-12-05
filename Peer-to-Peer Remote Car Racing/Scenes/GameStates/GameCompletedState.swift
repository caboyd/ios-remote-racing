//
//  GameCompletedState.swift
//  Peer-to-Peer Remote Car Racing
//
//  Created by user145437 on 11/18/18.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import GameplayKit
import SpriteKit

//Game Completed state corresponding with CompletedScene.sks
class GameCompletedState: GameOverlayState {
  
  override var overlaySceneFileName: String {
    return "CompletedScene"
  }
  
  override func didEnter(from previousState: GKState?) {
    SKTAudio.sharedInstance().backgroundMusicPlayer?.stop();
    super.didEnter(from: previousState)
  }
  
  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass is GameActiveState.Type;
  }
}
