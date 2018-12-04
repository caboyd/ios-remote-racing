//
//  JoystickHUD.swift
//  Peer-to-Peer Remote Car Racing
//
//  Created by user145437 on 11/17/18.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import Foundation
import SpriteKit
import CoreMotion

let screenBounds: CGRect = UIScreen.main.bounds;

fileprivate var js: AnalogJoystick = {
    let js = AnalogJoystick(diameter:90, colors:(UIColor.white, UIColor.gray));
    js.position = CGPoint(x:screenBounds.width * -0.5 + js.radius * 1.5  , y: screenBounds.height * -0.5 + js.radius * 1.5 )
    js.zPosition = 1;
    return js;
}();

enum ControlType : Int {
    
    case Joystick;
    case JoystickButtons;
    case TiltButtons;
}

protocol InputControl {
    var velocity: CGPoint { get set }
    var disabled:Bool { get set } ;
}

class JoystickInput: InputControl {
    
    var joystick: AnalogJoystick!;
    
    var velocity: CGPoint {
        get { return joystick.data.velocity }
        set { joystick.data.velocity = newValue }
    }
    
    init(analogJoystick : AnalogJoystick?){
        self.joystick = analogJoystick ?? js;
        self.disabled = false;
    }

    var disabled: Bool  {
        didSet {
            joystick.disabled = disabled;
        }

    }
}


class JoystickButtonInput:JoystickInput {
    override init(analogJoystick : AnalogJoystick?) {
        super.init(analogJoystick: analogJoystick);

        analogJoystick?.disabledYAxis = true;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class tiltcontrols:InputControl{
    deinit {
        self.motionManager.stopAccelerometerUpdates();
    }
    
    init(){
        self.motionManager = CMMotionManager();
        self.velocity = CGPoint();
        self.disabled = false;
        self.motionManager.accelerometerUpdateInterval = 0.1;
        self.motionManager.startAccelerometerUpdates(to: OperationQueue.main, withHandler:  {[weak self](data:CMAccelerometerData?,error:Error?)in
            var value = (data?.acceleration.y)! * 3;
            
            
            //swap value when phone orientation changes
            switch UIDevice.current.orientation {
            case .landscapeLeft:
                value = -value
            default:
                break;
            }
            
            if fabs(value) < 0.09
            {
                value = 0.0;
            }
            if value < -0.9 {
                value = -0.9
            } else if value > 0.9 {
                value = 0.9
            }
            self!.velocity.x = CGFloat(value);

        })
    }
        
    
    var motionManager:CMMotionManager
    var velocity: CGPoint
    
    var disabled: Bool
    
    func processUserMotion(forUpdate currentTime: CFTimeInterval){
        
    }
    
}
