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
    
    weak var gameSceneDelegate : BaseGameSceneProtocol?
    
    var lastUpdateTime : TimeInterval = 0
    var isSoftPaused : Bool = false;
    public var joystickEnabled = false;
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
    var gameEnded = false;
    
    var landBackground:SKTileMapNode!
    var trackSize: CGSize!;
    private var track:SKTileMapNode!
    
    var hud: UIHUD!;
    var touchControls : SceneRootNode!;
    
    private var buttons: [ButtonNode] = [];
    
    var inputControl: InputControl!;
   
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
        //GameSuccessState(gameScene: self)
        ])
    
    
    override func sceneDidLoad() {
        setupRace();
        setupCamera();
        
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view);
        physicsWorld.contactDelegate = self;
        
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
        guard let landBackground = childNode(withName: "//Background") as? SKTileMapNode else {
            fatalError("Background node not loaded");
        }
        
        self.landBackground = landBackground;
        
        
        guard let track = childNode(withName: "//Track") as? SKTileMapNode else {
            fatalError("Track node not loaded")
        }
        
        self.track = track;
        self.trackSize = track.mapSize;
        
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
        self.enumerateChildNodes(withName: "Waypoint*"){
            (node, stop) in
            self.waypoints += 1;
            node.alpha = 0;
        }
        
    }
    

    func setupHUD(){
        cam.removeAllChildren();
        hud = UIHUD();
        cam.addChild(hud);
        
        let tc = UITouchControlsJoystick();
        touchControls = tc
        inputControl = tc.inputControl;
        
        if(joystickEnabled){
            cam.addChild(touchControls);
            tc.pauseButton.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(BaseGameScene.pause))
            tc.addDebugHUD(gameScene: self);
        }
    }
    
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
    
    func resize() {
        displaySize = UIScreen.main.bounds;
        hud.resizeToDisplay();
        touchControls.resizeToDisplay();
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
        
        if let camera = cam, let pl = player {
            camera.position = pl.position;
            camera.zRotation = pl.zRotation;
            //print("cam: \(camera.position)");
            //print("player:  \(pl.position)");
        }
        
        if inputControl.velocity.y > 0 {
            player.accelForward(dt * Double(inputControl.velocity.y));
        }else{
            player.accelBackwards(dt * Double(inputControl.velocity.y));
        }
        if(abs(inputControl.velocity.x) > 0.05){
            player.turn(dt * Double(inputControl.velocity.x));
        }
        
         stateMachine.update(deltaTime: dt);
        
    }
    
    @objc func pause(){
        stateMachine.enter(GamePauseState.self);
    }
    
    @objc func cheatWin() {
        if var bestTime = SubmitScoreViewController.loadBestScoreLocally(trackName: name!){
            if bestTime == 0 {
                bestTime = 120;
                SubmitScoreViewController.saveBestScoreLocally(trackName: name!, score: bestTime);
            }
            totalTime = bestTime * 0.999;
        }
        win();
    }
    
    @objc func win(){
        gameEnded = true;
        inputControl.disabled = true;
        
        //If new score is better then present the submit score view
        if let bestTime = SubmitScoreViewController.loadBestScoreLocally(trackName: name!){
            if Double(totalTime) < bestTime {
                gameSceneDelegate?.presentSubmitScoreSubview(gameScene: self);
            }
        } else {
            gameSceneDelegate?.presentSubmitScoreSubview(gameScene: self);
        }

        stateMachine.enter(GameCompletedState.self);
    }
    
    func previousWaypoint(_ index:Int) -> Int {
        var result = index - 1;
        if result < 0 {
            result = waypoints - 1;
        }
        return result;
    }
    
    func getThumbnail() -> UIImage {
        let scale =  self.trackSize.width / self.size.width;
        cam.setScale(scale);
        self.displayLapLabel();
        let texture = SKView().texture(from: self);
        return UIImage(cgImage: (texture?.cgImage())!);
    }
    
}

extension BaseGameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        
        for waypoint in 0..<waypoints {
            let waypointName = "Waypoint\(waypoint)";
            if(contact.bodyA.node?.name == waypointName ||
                contact.bodyB.node?.name == waypointName) {
               
                if(lastWaypoint == previousWaypoint(waypoint)) {
                    //Update waypoint
                    lastWaypoint = waypoint;
                    if previousWaypoint(waypoint) > waypoint {
                        lap += 1;
                        //TODO: play lap sound
                        hud.bestLapNode.isHidden = false;
                        hud.bestLapTimeLabel.text = stringFromTimeInterval(interval: totalTime - summedLapTimes) as String;
                        summedLapTimes = totalTime;
                        
                        if(lap > totalLaps) {
                             win();
                        }
                       
                    }
                }
                break;
            }
        }
        


    }
}

