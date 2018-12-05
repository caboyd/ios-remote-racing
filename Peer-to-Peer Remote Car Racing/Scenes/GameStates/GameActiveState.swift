//
//  GameActiveState.swift
//  Peer-to-Peer Remote Car Racing
//
//  Created by user145437 on 11/18/18.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import SpriteKit
import GameplayKit


//Game Active state corresponding with BaseGameScene
class GameActiveState: GKState {
    
    unowned let gameScene: BaseGameScene
    var countdownActive = false;
    
    
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
    
    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)
        //Remove countdown actions when race is finished
        //so they don't run the old actions when new race is started
        if nextState is GameCompletedState {
            gameScene.cam.removeAllActions();
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        //Reset level of controller only when starting new race
        if gameScene.gameMode == .CONTROLLER {
            if (previousState is GameCompletedState) {
                restartLevel()
            }
                return;
        }
        
        //Start the countdown timer for new race started
        if previousState is GameCompletedState || previousState == nil{
            restartLevel()
            
            gameScene.isSoftPaused = true;
            self.gameScene.hud.countdownLabel.isHidden = false;
            self.gameScene.hud.countdownLabel.text = "3";
            
            let wait2sec = SKAction.wait(forDuration: 2);
            let wait1sec = SKAction.wait(forDuration: 1);
            let fade = SKAction.fadeAlpha(by: -1, duration: 0.5);
            
            let playsound = SKAction.run {
                SKTAudio.sharedInstance().playBackgroundMusic("race_countdown.mp3");
                SKTAudio.sharedInstance().backgroundMusicPlayer?.numberOfLoops = 0;
            }

            let action1 = SKAction.run {
                
                self.gameScene.hud.countdownLabel.alpha = 1.0;
                self.gameScene.hud.countdownLabel.run(fade);
                self.gameScene.hud.countdownLabel.text = "3";
            }
            
            //set label node 2
            let action2 = SKAction.run {
                self.gameScene.hud.countdownLabel.alpha = 1.0;
                self.gameScene.hud.countdownLabel.run(fade);
                self.gameScene.hud.countdownLabel.text = "2";
            }
            
            let action3 = SKAction.run {
                self.gameScene.hud.countdownLabel.text = "1";
                self.gameScene.hud.countdownLabel.alpha = 1.0;
                self.gameScene.hud.countdownLabel.run(fade);
            }
            
            let unpause = SKAction.run {
                self.gameScene.isSoftPaused = false
                self.gameScene.hud.countdownLabel.isHidden = true;
                self.countdownActive = false;
                
            }
            let stopMusic = SKAction.run {
                SKTAudio.sharedInstance().stopBackgroundMusic()
            }
            
            countdownActive = true;
            gameScene.cam.run(SKAction.sequence([wait2sec,playsound, action1, wait1sec, action2, wait1sec, action3,wait1sec, unpause, wait2sec, stopMusic]));
            
        }
        
        //Start unpause countdown of 1 second only when countdown is not active
        if previousState is GamePauseState && countdownActive == false {
            let waitTime = 1.0;
            gameScene.isSoftPaused = true;
            let wait = SKAction.wait(forDuration: waitTime);
            let unpause = SKAction.run { self.gameScene.isSoftPaused = false }
            gameScene.cam.run(SKAction.sequence([wait, unpause]));
            
        }
    
    }
    
    
    override func update(deltaTime dt: TimeInterval) {
        super.update(deltaTime: dt)
        
        if gameScene.isPaused {
            return
        }
        
        if gameScene.gameEnded {
            return;
        }
        
        
        if gameScene.gameMode != .CONTROLLER{
            gameScene.totalTime += dt;
        }
        
        updateLabels();
    }
    
    
    private func restartLevel() {
        
        //Reset all game variables
        previousTimeInterval = 0;
        gameScene.lastUpdateTime = 0;
        gameScene.lastWaypoint = 0;
        gameScene.lap = 1;
        gameScene.gameEnded = false;
        gameScene.summedLapTimes = 0;
        gameScene.totalTime = 0;
        
        //Removes old player if it exists
        gameScene.player?.removeFromParent();
        
        //Create a player and put it in the scene at the start position
        gameScene.player = Player(position: gameScene.startPosition, carTextureName: gameScene.carType, gameMode: gameScene.gameMode);
        gameScene.addChild(gameScene.player!);
        
        //Move camera to player position
        if gameScene.gameMode != .CONTROLLER {
            gameScene.cam.position = gameScene.player.position;
            gameScene.cam.zRotation = gameScene.player.zRotation;
        }
        
        //Re-hide best lap label
        gameScene.hud.bestLapNode.isHidden = true;
        
        //Update the labels with the reset values
        updateLabels()
    }
    
    private func updateLabels() {
        gameScene.hud.lapLabel.text = "Lap \(gameScene.lap)/\(gameScene.totalLaps)";
        gameScene.hud.timeLabel.text = stringFromTimeInterval(interval: gameScene.totalTime) as String;
        gameScene.hud.speedLabel.text = "\(Int(gameScene.player.physicsBody?.velocity.length() ?? 0))";
    }
}

