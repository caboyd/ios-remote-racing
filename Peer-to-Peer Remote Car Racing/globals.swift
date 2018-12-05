//
//  globals.swift
//  Peer-to-Peer Remote Car Racing
//
//  Created by user145437 on 11/19/18.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import Foundation
import SpriteKit


//GLOBAL VARIABLES ---------------------------------------------------

//Size of screen and aspect ratio
var displaySize: CGRect = UIScreen.main.bounds {
    didSet {
        displayAspect = displaySize.width / displaySize.height;
    }
};
var displayAspect = displaySize.width / displaySize.height;

//Common color used for UI
let systemYellowColor = UIColor(red:255 / 255, green: 204 / 255, blue: 0, alpha: 1);



//HELPER FUNCTIONS ---------------------------------------------------


//Convert a time Interval in seconds to the format mm:ss.MMM
// example 00:00.000
func stringFromTimeInterval(interval: TimeInterval) -> NSString {
    let ti = NSInteger(interval);
    
    let ms = Int(interval.truncatingRemainder(dividingBy: 1) * 1000);
    
    let seconds = ti % 60;
    let minutes = (ti / 60) % 60;
    
    return NSString(format: "%0.2d:%0.2d.%0.3d", minutes, seconds, ms);
}
