//
//  GameScene.swift
//  race prototype
//
//  Created by Christopher Boyd on 2018-11-06.
//  Copyright © 2018 Christopher Boyd. All rights reserved.
//

import SpriteKit
import GameplayKit

@objc
protocol BaseGameSceneProtocol : class {
    func presentSubmitScoreSubview(gameScene: BaseGameScene);
    func quitToMenu();
    func quitToTrackSelection();
}

enum GameMode: Int {
    case SOLO
    case CONTROLLER
    case DISPLAY
}

class BaseGameScene: SKScene {
    
    weak var networkService : NetworkService?;
    weak var gameSceneDelegate : BaseGameSceneProtocol?
    var gameMode: GameMode = .SOLO;
    var update: UInt64 = 0;
    let updatesPerCarData: UInt64 = 6; // 10 per second
    let updatesPerInputControl: UInt64 = 6; //10 per second
    
    var lastUpdateTime : TimeInterval = 0
    var isSoftPaused : Bool = false;
    var debugMode = false;
    
    var cam: SKCameraNode!
    
    var startPosition: CGPoint!;
    var carType: String!;
    var player: Player!;
    
    var waypoints: Int = 0;
    var lap: Int = 1;
    var lastWaypoint: Int = 0;
    var totalLaps:Int = 0;
    var totalTime: TimeInterval = 0;
    var summedLapTimes: TimeInterval = 0;
    var bestLapTime: TimeInterval = 0;
    var gameEnded = false;
    
    private var landBackground:SKTileMapNode!
    var trackSize: CGSize!;
    private var track:SKTileMapNode!
    
    var hud: UIHUD!;
    var touchControls : SceneRootNode!;
    var inputControl: InputControl!;
    
    private var buttons: [ButtonNode] = [];
    
    var buttonsEnabled : Bool = true {
        didSet {
            buttons.forEach { (btn) in
                btn.isUserInteractionEnabled = buttonsEnabled;
            }
        }
    }
   
    var overlay: SceneOverlay? {
        didSet {
            buttons = [];
            oldValue?.backgroundNode.removeFromParent();
            
            if let overlay = overlay, let camera = camera {
                //showing overlay
               
                camera.addChild(overlay.backgroundNode);
                overlay.updateScale();
                
                buttons = findAllButtonsInScene();
                
                
            } else {
                //dismissing overlay

            }
        }
    }
    
    lazy var stateMachine: GKStateMachine = GKStateMachine(states: [
        GameActiveState(gameScene: self),
        GamePauseState(gameScene: self),
        GameCompletedState(gameScene: self),

        ])
    
    
    override func sceneDidLoad() {
        setupRace();
        setupCamera();
        
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view);
        
        if gameMode == .CONTROLLER {
            fitWholeSceneInCamera(0.5) ;
           
            //Remove the whole scene except track
            self.childNode(withName : "//trackroot")?.removeFromParent();
            
            //make the track darker
            track.color = .gray;
            track.colorBlendFactor = 0.8;
            track.removeFromParent();
            self.addChild(track);

            
        } else {
            physicsWorld.contactDelegate = self
        }
        
        setupHUD();
        stateMachine.enter(GameActiveState.self);
        
    }
    
    func setupCamera(){
        cam = SKCameraNode();
        self.camera = cam;
        self.addChild(cam!);
        cam.setScale(3 * 320 / displaySize.height );
    }
    
    func setupRace(){
        guard let track = childNode(withName: "//Track") as? SKTileMapNode else {
            fatalError("Track node not loaded")
        }
        self.track = track;
        self.trackSize = track.mapSize;
        
        guard let landBackground = childNode(withName: "//Background") as? SKTileMapNode else {
            fatalError("Background node not loaded");
        }
        self.landBackground = landBackground;
        
        //Get start position for car
        for row in 0..<track.numberOfRows {
            for col in 0..<track.numberOfColumns {
                let tile = track.tileGroup(atColumn: col, row: row)
                if (tile != nil)
                {
                    if tile?.name == "AsphaltStartPosition1" {
                        startPosition = track.centerOfTile(atColumn: col, row: row);
                    }
                }
            }
        }
        
        //Count number of waypoint in this track
        self.waypoints = 0;
        self.enumerateChildNodes(withName: "//Waypoint*"){
            (node, stop) in
            self.waypoints += 1;
            node.alpha = 0;
        }
    }
    

    func setupHUD(){
        cam.removeAllChildren();

        let buttonsEnabled = UserDefaults.standard.bool(forKey: "JoystickButtons");
        
        let tc = UITouchControlsJoystick(gameScene: self, buttonsEnabled: buttonsEnabled);
        touchControls = tc
        inputControl = tc.inputControl;
        hud = UIHUD();
        cam.addChild(hud);
        
        if gameMode == .CONTROLLER{
            hud.timersNode.isHidden = true;
            hud.speedNode.isHidden = true;
            
        }
        if gameMode != .DISPLAY {
            
            cam.addChild(touchControls);
            if debugMode {
                tc.addDebugHUD(gameScene: self);
            }
        }
    }
    

    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        self.lastUpdateTime = currentTime

        if isSoftPaused {
            return;
        }
        
        if gameEnded {
            return;
        }
        
        update += 1;
        
        if gameMode == .CONTROLLER {
            if (update % updatesPerInputControl == 0){
                networkService?.sendInputControl(inputControl: inputControl);
            }
            
            stateMachine.update(deltaTime: dt);
            return;
        } else if gameMode == .DISPLAY {
            if update % updatesPerCarData == 0 {
                networkService?.sendCarData(position: player.position, angle: player.zRotation)
            }
            
        }
        
        //Move the camera to follow the player
        if let camera = cam, let pl = player {
            camera.position = pl.position;
            camera.zRotation = pl.zRotation;
        }
        
        if inputControl.velocity.y > 0 {
            player.accelForward(dt * Double(inputControl.velocity.y));
        }else{
            player.accelBackwards(dt * Double(inputControl.velocity.y));
        }
        
        //Turn the player depending on x value of joystick
        if(abs(inputControl.velocity.x) > 0.05){
            var turn = dt * Double(inputControl.velocity.x);
            
            //Invert turn when reversing because it it more natural
            if inputControl.velocity.y < 0 {
                turn = -turn;
            }
 
            player.turn(turn);
        }
        
        //Update the active game state
         stateMachine.update(deltaTime: dt);
        
    }
    

    
    //Enter pause state
    @objc func pause(){
        networkService?.send(messageType: .PAUSE);
        stateMachine.enter(GamePauseState.self);
    }
    
    
    //win game istantly with new record
    //Controller: sends debug win message to display
    @objc func debugWin() {
        //set bad score to always get a better time
        SubmitScoreViewController.saveBestScoreLocally(trackName: name!, score: 9999);
        
        if gameMode == .CONTROLLER {
           networkService?.send(messageType: .DEBUG_WIN)
        } else {
            win();
        }
    }
    
    //Win game
    //Solo: presents the submit score view if new record
    //Controller: presents the submit score view if new record
    //Display: Sends race finished message to controller device.
    @objc func win(){
        gameEnded = true;
        inputControl.disabled = true;
        stateMachine.enter(GameCompletedState.self);
        
        if gameMode != .CONTROLLER {
            networkService?.sendRaceFinished(time: totalTime);
            SKTAudio.sharedInstance().playSoundEffect("race_finished.wav");
        }
        
        if gameMode != .DISPLAY {
            //If new score is better then present the submit score view
            if let bestTime = SubmitScoreViewController.loadBestScoreLocally(trackName: name!){
                if Double(totalTime) < bestTime {
                    gameSceneDelegate?.presentSubmitScoreSubview(gameScene: self);
                }
            } else {
                gameSceneDelegate?.presentSubmitScoreSubview(gameScene: self);
            }
        }
    }
    
    func resize() {
        displaySize = UIScreen.main.bounds;
        hud.resizeToDisplay();
        touchControls.resizeToDisplay();
    }
    
    func fitWholeSceneInCamera(_ mult: CGFloat = 1.0) {
        let scale =  self.trackSize.width / self.size.width;
        cam.setScale(scale / mult);
    }
    
    func vibratePhone() {
        let generator = UIImpactFeedbackGenerator(style: .medium);
        generator.impactOccurred();
        
    }
}

extension BaseGameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        
        //car impact with waypoints
        for waypoint in 0..<waypoints {
            let waypointName = "Waypoint\(waypoint)";
            
            //car impact with wal
            if (contact.bodyA.contactTestBitMask & contact.bodyB.categoryBitMask) == 2 &&
                ((contact.bodyB.node?.name)! == waypointName) {
                collisionBetween(player: contact.bodyA.node!, waypoint: waypoint)
                break;
            } else if (contact.bodyB.contactTestBitMask & contact.bodyA.categoryBitMask) == 2 &&
                ((contact.bodyA.node?.name)! == waypointName) {
                collisionBetween(player: contact.bodyB.node!, waypoint: waypoint)
                break;
            }
        }
        
        //car impact with wal
        if (contact.bodyA.contactTestBitMask & contact.bodyB.categoryBitMask) == 1 {
            collisionBetween(player: contact.bodyA.node! , wall: contact.bodyB.node!)
        } else if (contact.bodyB.contactTestBitMask & contact.bodyA.categoryBitMask) == 1 {
            collisionBetween(player: contact.bodyB.node! , wall: contact.bodyA.node!)
        }
    }
    
    func previousWaypoint(_ index:Int) -> Int {
        var result = index - 1;
        if result < 0 {
            result = waypoints - 1;
        }
        return result;
    }
    
    func collisionBetween(player: SKNode, wall: SKNode){
        //send vibrate to controller
        networkService?.send(messageType: .VIBRATE);
        
        //play crash sound
        SKTAudio.sharedInstance().playSoundEffect("thud.wav")
        
        if gameMode == .SOLO {
            vibratePhone();
        }
    }
    
    func collisionBetween(player: SKNode, waypoint: Int){
        if(lastWaypoint == previousWaypoint(waypoint)) {
            //Update waypoint
            lastWaypoint = waypoint;
            
            //waypoint looped back to 0 so we did a lap
            if previousWaypoint(waypoint) > waypoint {
                lap += 1;
                
                
                
                //show best lap on screen
                if hud.bestLapNode.isHidden {
                    bestLapTime = totalTime - summedLapTimes;
                    hud.bestLapNode.isHidden = false;
                    hud.bestLapTimeLabel.text = stringFromTimeInterval(interval: bestLapTime) as String;
                } else if totalTime - summedLapTimes < bestLapTime {
                    bestLapTime = totalTime - summedLapTimes;
                    hud.bestLapTimeLabel.text = stringFromTimeInterval(interval: bestLapTime) as String;
                }

                
                summedLapTimes = totalTime;
                
                if(lap > totalLaps) {
                    win();
                } else {
                    //lay lap sound
                    SKTAudio.sharedInstance().playSoundEffect("lap_finished.wav");
                    networkService?.send(messageType: .LAP_FINISHED);
                }
            }
        }
    }

}

extension BaseGameScene : NetworkServiceDelegate {
    func handleMessage(message: MessageBase) {
        switch gameMode {
        case .DISPLAY:
            handleMessageDisplay(message: message);
        case .CONTROLLER:
            handleMessageController(message: message);
        case .SOLO:
            fatalError();
        }
    }
    
    private func handleMessageDisplay(message: MessageBase) {
       
        switch message.type {
        case .INPUT_CONTROL:
            inputControl.velocity = (message as! InputControlMessage).velocity;
        case .PAUSE:
            stateMachine.enter(GamePauseState.self);
        case .RESUME:
            stateMachine.enter(GameActiveState.self);
        case .DEBUG_WIN:
            debugWin();
        case .DISCONNECT:
            gameSceneDelegate?.quitToMenu();
            networkService?.session.disconnect();
        case .RESTART:
            stateMachine.enter(GameActiveState.self);
        case .NAV_TRACK_SELECT:
            gameSceneDelegate?.quitToTrackSelection();
        default:
            fatalError("bad message in handleMessageDisplay \(message.description)")
        }
    }
    
    private func handleMessageController(message: MessageBase) {
        switch message.type {
        case .CAR_DATA:
            let m = message as! CarDataMessage;
            player.setPositionRotation(m.position,m.angle);
        case .RACE_FINISHED:
            let m = message as! RaceFinishedMessage;
            totalTime = m.time;
            win();
        case .LAP_FINISHED:
            lap += 1;
        case .DISCONNECT:
            gameSceneDelegate?.quitToMenu();
        case .VIBRATE:
            vibratePhone();
        default:
            fatalError("bad message in handleMessageController \(message.description)")
        }
    }
}


//These funcions are for rendering the track thumbnails
//and aren't used in the game
extension BaseGameScene {
    
    func displayLapLabel() {
        //cam.childNode(withName: "laps")?.removeFromParent();
        let lap = totalLaps != 1 ? "Laps" : "Lap";
        let label = SKLabelNode(text: "\(totalLaps) \(lap)")
        label.name = "laps"
        label.zPosition = 1;
        label.fontColor = systemYellowColor;
        label.fontName = "Futura-MediumItalic"
        label.fontSize = 350;
        label.verticalAlignmentMode = .top
        label.position = CGPoint(x: 0, y: self.size.height / 2);
        cam.addChild(label);
    }
    
    func getThumbnail() -> UIImage {
        fitWholeSceneInCamera();
        self.displayLapLabel();
        let texture = SKView().texture(from: self);
        return UIImage(cgImage: (texture?.cgImage())!);
    }
}
