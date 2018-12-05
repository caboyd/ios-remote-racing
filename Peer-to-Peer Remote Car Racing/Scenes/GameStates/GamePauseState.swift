//
//  GamePauseState.swift
//  Peer-to-Peer Remote Car Racing
//
//  Created by user145437 on 11/18/18.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import SpriteKit
import GameplayKit

//Pause state corresponding with PauseScene.sks
class GamePauseState: GameOverlayState {
  
  override var overlaySceneFileName: String {
    return "PauseScene"
  }
  
  override func didEnter(from previousState: GKState?) {
    super.didEnter(from: previousState)
    SKTAudio.sharedInstance().pauseBackgroundMusic();
    gameScene.isPaused = true
    gameScene.lastUpdateTime = 0;
  }
  
  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass is GameActiveState.Type
  }
  
  override func willExit(to nextState: GKState) {
    super.willExit(to: nextState)
    SKTAudio.sharedInstance().resumeBackgroundMusic();
    gameScene.isPaused = false

  }
}
