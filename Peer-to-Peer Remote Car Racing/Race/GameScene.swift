//
//  GameScene.swift
//  race prototype
//
//  Created by Christopher Boyd on 2018-11-06.
//  Copyright © 2018 Christopher Boyd. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    
    public var joystickEnabled = false;
    private var cam: SKCameraNode!
    private var player: Player!;
    private var currentWaypoint: Int = 0;
    private var totalLaps:Int = 3;
    private var lap:Int = 1;
    
    private var landBackground:SKTileMapNode!
    private var track:SKTileMapNode!
    private var lapLabel:SKLabelNode!;
    
    private let displaySize: CGRect = UIScreen.main.bounds;
    
    lazy var joystick: AnalogJoystick = {
        let js = AnalogJoystick(diameter:90, colors:(UIColor.white, UIColor.gray));
        js.position = CGPoint(x: displaySize.width * -0.5 + js.radius - 35 , y: displaySize.height * -0.5 + js.radius - 15)
        js.zPosition = 1;
        return js;
    }()
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        
    }

    override func didMove(to view: SKView) {
        super.didMove(to: view);
        physicsWorld.contactDelegate = self;
        setupRace();
        setupCamera();
        setupHUD();
        
        if(joystickEnabled){
            cam.addChild(joystick);
        }
    }
    
    func setupCamera(){
        cam = SKCameraNode();
        self.camera = cam;
        cam.setScale(2);
        cam.position = player.position;
        self.addChild(cam!);
        print("added cam");
    }
    
    func setupRace(){
        guard let landBackground = childNode(withName: "Background") as? SKTileMapNode else {
            fatalError("Background node not loaded");
        }
        
        self.landBackground = landBackground;
        
        guard let track = childNode(withName: "Track") as? SKTileMapNode else {
            fatalError("Track node not loaded")
        }
        
        self.track = track;
        
        var startPosition = CGPoint();
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
        
        player = Player(position: startPosition);
        self.addChild(player!);
    }
    
    func setupHUD(){
        lapLabel = SKLabelNode(fontNamed: "Chalkduster");
        lapLabel.text = "Lap \(lap)/\(totalLaps)";
        lapLabel.fontColor = SKColor.yellow;
        lapLabel.zPosition = 2;
        lapLabel.position = CGPoint(x: displaySize.width * 0.5 - 10, y: displaySize.height * 0.5 - 2)
        cam.addChild(lapLabel);
    
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
        
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        if let camera = cam, let pl = player {
            camera.position = pl.position;
            camera.zRotation = pl.zRotation;
            //print("cam: \(camera.position)");
            //print("player:  \(pl.position)");
        }
        if joystick.data.velocity.y > 0 {
            player.accelForward(dt * Double(joystick.data.velocity.y));
        }else{
            player.accelBackwards(dt * Double(joystick.data.velocity.y));
        }
        if(abs(joystick.data.velocity.x) > 7){
             player.turn(dt * Double(joystick.data.velocity.x));
        }
       
    }
    
    

}

extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        
        if(contact.bodyA.node?.name == "Waypoint0" || contact.bodyB.node?.name == "Waypoint0") {
            if(currentWaypoint == 1){
                print("hit waypoint0")
                currentWaypoint = 0;
                lap += 1;
                lapLabel.text = "Lap \(lap)/\(totalLaps)";
            }
        }
        
        if(contact.bodyA.node?.name == "Waypoint1" || contact.bodyB.node?.name == "Waypoint1") {
            if(currentWaypoint == 0){
                print("hit waypoint1")
                currentWaypoint = 1;
            }
        }
    }
}
