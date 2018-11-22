/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import SpriteKit
import GameplayKit

class GameActiveState: GKState {

  unowned let gameScene: BaseGameScene
  

  private var previousTimeInterval: TimeInterval = 0
  
  init(gameScene: BaseGameScene) {
    self.gameScene = gameScene
    super.init()
    
    restartLevel()  }
  
  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    switch stateClass {
      case is GamePauseState.Type, is GameCompletedState.Type:
        return true
      default:
        return false
    }
  }
  
  override func didEnter(from previousState: GKState?) {
    super.didEnter(from: previousState)

    var pauseTime = 3.0;
    if previousState is GameCompletedState {
      restartLevel()
    }
    if previousState is GamePauseState {
        pauseTime -= 1.5;
    }
    
    gameScene.isSoftPaused = true;
    let wait = SKAction.wait(forDuration: pauseTime);
    let unpause = SKAction.run { self.gameScene.isSoftPaused = false }
    gameScene.cam.run(SKAction.sequence([wait, unpause]));
  }
 
  
  override func update(deltaTime dt: TimeInterval) {
    super.update(deltaTime: dt)
    
    if gameScene.isPaused {
      return
    }

    if gameScene.gameEnded {
        return;
    }
    
    //Update Here
    gameScene.totalTime += dt;
    
    updateLabels();
  }
  
 
  private func restartLevel() {
    previousTimeInterval = 0;
    gameScene.lastUpdateTime = 0;
    gameScene.lastWaypoint = 0;
    gameScene.lap = 1;
    gameScene.gameEnded = false;
    gameScene.summedLapTimes = 0;
    gameScene.totalTime = 0;
    gameScene.player?.removeFromParent();
    gameScene.player = Player(position: gameScene.startPosition);
    gameScene.addChild(gameScene.player!);
    gameScene.cam.position = gameScene.player.position;
    gameScene.cam.zRotation = gameScene.player.zRotation;
    gameScene.hud.bestLapNode.isHidden = true;
    gameScene.inputControl.disabled = false;
    
    updateLabels()
  }
  
  private func updateLabels() {
    gameScene.hud.lapLabel.text = "Lap \(gameScene.lap)/\(gameScene.totalLaps)";
    
    gameScene.hud.timeLabel.text = stringFromTimeInterval(interval: gameScene.totalTime) as String;
    gameScene.hud.speedLabel.text = "\(Int(gameScene.player.physicsBody?.velocity.length() ?? 0))";
  }
}


func stringFromTimeInterval(interval: TimeInterval) -> NSString {
    let ti = NSInteger(interval);
    
    let ms = Int(interval.truncatingRemainder(dividingBy: 1) * 1000);
    
    let seconds = ti % 60;
    let minutes = (ti / 60) % 60;
    
    return NSString(format: "%0.2d:%0.2d.%0.3d", minutes, seconds, ms);
}
