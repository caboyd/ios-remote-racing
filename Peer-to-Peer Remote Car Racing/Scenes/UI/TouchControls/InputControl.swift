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

//The joystick object used
fileprivate var js: AnalogJoystick = {
    let js = AnalogJoystick(diameter:90, colors:(UIColor.white, UIColor.gray));
    js.position = CGPoint(x:screenBounds.width * -0.5 + js.radius * 1.5  , y: screenBounds.height * -0.5 + js.radius * 1.5 )
    js.zPosition = 1;
    return js;
}();

//Different possible control type configuratoins for playing
enum ControlType : Int {
    
    case Joystick;
    case JoystickButtons;
    case TiltButtons;
}

//The protocol that the different inputs must adhere to
//This protocol is necessary to allow for different control types
//to be used and sent over the network
protocol InputControl {
    var velocity: CGPoint { get set }
    var disabled:Bool { get set } ;
}

//Single joystick input, moves in x,y direction
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


//Joystick input, moves in x direction
//button input, gas button for forward and reverse button for reverse
class JoystickButtonInput:JoystickInput {
    override init(analogJoystick : AnalogJoystick?) {
        super.init(analogJoystick: analogJoystick);

        analogJoystick?.disabledYAxis = true;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//Tilt input, moves velocity in x direction
//button input, gas button for forward and reverse button for reverse
class TiltControls:InputControl{
    var motionManager:CMMotionManager
    var velocity: CGPoint = CGPoint();
    var disabled: Bool = false
    
    init(){
        //Setup motion manager
        self.motionManager = CMMotionManager();
        self.motionManager.accelerometerUpdateInterval = 1/60;
        
        //Start the listener for the motion manager with a handler
        self.motionManager.startAccelerometerUpdates(to: OperationQueue.main, withHandler:  {[weak self](data:CMAccelerometerData?,error:Error?)in
            
            //Grab the y acceleration and multiply by 3 to make it more responsive
            var value = (data?.acceleration.y)! * 3;
            
            
            //swap value when phone orientation changes
            //This is so turning isnt wrong when phone upside down
            switch UIDevice.current.orientation {
            case .landscapeLeft:
                value = -value
            default:
                break;
            }
            
            //Accelerometer readings less than 0.07 are ignored
            //Makes it easier to go straight when device is only
            //slightly titled
            if fabs(value) < 0.07
            {
                value = 0.0;
            }
            
            //Clamp the acceleration to +- 0.9
            //Prevents turning too fast
            if value < -0.9 {
                value = -0.9
            } else if value > 0.9 {
                value = 0.9
            }
            
            //When the race ends the handler may still have operations left
            //in the queue so we must check that the variable exists or we
            //will crash the app
            if (self?.velocity) != nil{
                self!.velocity.x = CGFloat(value);
            }
        })
    }
    
    deinit {
        self.motionManager.stopAccelerometerUpdates();
    }

}
