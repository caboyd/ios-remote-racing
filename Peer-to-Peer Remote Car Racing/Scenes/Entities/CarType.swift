//
//  CarType.swift
//  Peer-to-Peer Remote Car Racing
//
//  Created by user145437 on 11/23/18.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import Foundation
import SpriteKit
enum CarColor: Int {
    case black
    case blue
    case green
    case red
    case yellow
    
    var string: String {
        return String("\(self)");
    }
    
    mutating func next() {
        self = CarColor(rawValue: rawValue + 1) ?? CarColor(rawValue: 0)!
    }
    
}

class CarID {

    static let minCarID = 1;
    static let maxCarID = 5;
    
    static func getNextID(_ id: Int) -> Int {
        if id + 1 > maxCarID {
            return minCarID;
        }
        return id + 1;
    }
    
    static func getPreviousID(_ id: Int) -> Int {
        if id - 1 < minCarID {
           return maxCarID;
        }
        return id - 1;
    }
}



func getCarTextureName(id: Int, color:CarColor) -> String{
    return "car_\(color)_\(id)";
}
