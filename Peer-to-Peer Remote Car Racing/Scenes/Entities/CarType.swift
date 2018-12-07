//
//  CarType.swift
//  Peer-to-Peer Remote Car Racing
//
//  Created by user145437 on 11/23/18.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import Foundation
import SpriteKit

//Enum representing selectable car colors
enum CarColor: Int {
    case black
    case blue
    case green
    case red
    case yellow
    
    var string: String {
        return String("\(self)");
    }
    
    //Helper to loop through the enum
    mutating func next() {
        self = CarColor(rawValue: rawValue + 1) ?? CarColor(rawValue: 0)!
    }
    
}

//Helper class to loop through available car IDs
class CarID {

    static let MIN = 1;
    static let MAX = 5;
    
    static func getNextID(_ id: Int) -> Int {
        if id + 1 > MAX {
            return MIN;
        }
        return id + 1;
    }
    
    static func getPreviousID(_ id: Int) -> Int {
        if id - 1 < MIN {
           return MAX;
        }
        return id - 1;
    }
}

//Helper class to loop through available track IDs
class TrackID {
    static let MIN = 1;
    static let MAX = 2;
    
    static func getNextID(_ id: Int) -> Int {
        if id + 1 > MAX {
            return MIN;
        }
        return id + 1;
    }
    
    static func getPreviousID(_ id: Int) -> Int {
        if id - 1 < MIN {
            return MAX;
        }
        return id - 1;
    }
    
    //Converts a track ID to the name of the track
    //Ex. Track1 and Track2
    static func toString(_ id: Int) -> String {
        return "Track\(id)"
    }
}

//Returns the name of the car texture
//Ex. id=1, color=red
//returns car_red_1
func getCarTextureName(id: Int, color:CarColor) -> String{
    return "car_\(color)_\(id)";
}
