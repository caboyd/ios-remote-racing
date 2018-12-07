//
//  Player.swift
//  race prototype
//
//  Created by user145437 on 11/10/18.
//  Copyright © 2018 Christopher Boyd. All rights reserved.
//

import Foundation
import SpriteKit


/*
 This class represents the car sprite node for the player
 
 */
class Player : SKSpriteNode {
    var velocity: CGVector
    var accel: CGVector;
    
    static let ACCEL_FORWARD = 3000.0 ;
    static let ACCEL_BACKWARD = 1700.0 ;
    static let TURN = 0.3;
   
    //New player with given texture,
    //gamemode of controller makes the player a triangle
    init(position: CGPoint, carTextureName: String = "car_black_1", gameMode: GameMode) {
        self.velocity = CGVector(dx: 0,dy: 0);
        self.accel = CGVector(dx: 0,dy: 0);
        
        //Set car texture to one passed in as param
        var texture = SKTexture(imageNamed: carTextureName);
        
        //Set car texture to a yellow triangle
        if gameMode == .CONTROLLER {
            let path = UIBezierPath();
            path.move(to: CGPoint(x: 0, y: 90))
            path.addLine(to: CGPoint(x: -70, y: -90));
            path.addLine(to: CGPoint(x: 70, y: -90));
            path.addLine(to: CGPoint(x: 0, y: 90));
            let triangle = SKShapeNode(path: path.cgPath);
            triangle.fillColor = systemYellowColor;
            texture = SKView().texture(from: triangle)!;
        }
        
        //Initialize the SKSpriteNode
        super.init(texture: texture, color: UIColor.clear, size: texture.size());
        
        self.name = "Player"
        self.position = position;
        self.zPosition = 1;
        
        
        //Setup physics if not controller device
        if gameMode != .CONTROLLER {
            physicsBody = SKPhysicsBody(texture: texture, size: texture.size());
        }
        
        if let physics = physicsBody {
            physics.affectedByGravity = false;
            physics.allowsRotation = true;
            physics.isDynamic = true;
            physics.linearDamping = 5
            physics.angularDamping = 2;
            physics.collisionBitMask = 1;
            physics.contactTestBitMask = 3;
            physics.mass = 1;
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Set the position and rotation of the car
    //Used in the controller device
    func setPositionRotation(_ position: CGPoint, _ angle: CGFloat) {
        self.position = position;
        self.zRotation = angle;
    }
    
    //Apply a forward impulse to the car based on time passed
    func accelForward(_ delta_time: TimeInterval){
        let speed = CGFloat(delta_time * Player.ACCEL_FORWARD);
 
        let rot = zRotation + .pi/2;
        let dir = CGVector(dx: cos(rot), dy: sin(rot));
        physicsBody?.applyImpulse(dir * speed);
    }
    
    //Apply a backward impulse to the car based on time passed
    func accelBackwards(_ delta_time: TimeInterval){
        let speed = CGFloat(delta_time * Player.ACCEL_BACKWARD);
        
        let rot = zRotation + .pi/2;
        let dir = CGVector(dx: cos(rot), dy: sin(rot));
        physicsBody?.applyImpulse( dir * speed);
    }
    
    //Apply an angular impulse to the car based on time passed
    func turn(_ delta_time: TimeInterval){
        let speed = CGFloat(delta_time * -Player.TURN);
        physicsBody?.applyAngularImpulse(speed);
       
    }
}

extension SKSpriteNode {
    func resetPhysicsForcesAndVelocity() {
        zRotation = 0
        if let pBody = physicsBody {
            pBody.angularVelocity = 0
            pBody.velocity = .zero
        }
    }
}

