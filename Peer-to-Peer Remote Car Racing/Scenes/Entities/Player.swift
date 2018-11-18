//
//  Player.swift
//  race prototype
//
//  Created by user145437 on 11/10/18.
//  Copyright © 2018 Christopher Boyd. All rights reserved.
//

import Foundation
import SpriteKit

class Player : SKSpriteNode {
    var velocity: CGVector
    var accel: CGVector;
    
    static let ACCEL_FORWARD = 30000.0;
    static let ACCEL_BACKWARD = 17000.0;
    static let TURN = 0.09;
   
    
    init(position: CGPoint) {
        self.velocity = CGVector(dx: 0,dy: 0);
        self.accel = CGVector(dx: 0,dy: 0);
        let texture = SKTexture(imageNamed: "car_black_1");
        super.init(texture: texture, color: UIColor.clear, size: texture.size());
        self.position = position;
        
        physicsBody = SKPhysicsBody(texture: texture, size: texture.size());
        if let physics = physicsBody {
            physics.affectedByGravity = false;
            physics.allowsRotation = true;
            physics.isDynamic = true;
            physics.linearDamping = 5
            physics.angularDamping = 2;
            physics.collisionBitMask = 1;
            physics.contactTestBitMask = 2;
            
        }
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ delta_time: TimeInterval){
        
    }
    
    func accelForward(_ delta_time: TimeInterval){
        let speed = CGFloat(delta_time * Player.ACCEL_FORWARD);
        
        let rot = zRotation + .pi/2;
        let dir = CGVector(dx: cos(rot), dy: sin(rot));
        physicsBody?.applyForce(dir * speed);
    }
    
    func accelBackwards(_ delta_time: TimeInterval){
        let speed = CGFloat(delta_time * Player.ACCEL_BACKWARD);
        
        let rot = zRotation + .pi/2;
        let dir = CGVector(dx: cos(rot), dy: sin(rot));
        physicsBody?.applyForce( dir * speed);
    }
    
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

