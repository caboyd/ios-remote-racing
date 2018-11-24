//
//  CarDataMessage.swift
//  Peer-to-Peer Remote Car Racing
//
//  Created by user145437 on 11/24/18.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import Foundation
import CoreGraphics

class CarDataMessage : MessageBase {
    var position: CGPoint
    var direction: CGPoint
    
    required init(position: CGPoint, direction: CGPoint) {
        self.position = position;
        self.direction = direction;
        super.init(type: .CAR_DATA);
        
    }
    
    static func from(data _data: Data) -> Self {
        let firstByte = _data[0];
        assert(MessageType(rawValue: firstByte) == .CAR_DATA);
        var data = _data.dropFirst();
        
        guard let pos =  CGPoint(data: data.prefix(upTo: 16)) else {
            fatalError("Bad data \(CarDataMessage.self)")
        };
        data.removeSubrange(0..<16);
        guard let dir = CGPoint(data: data.prefix(upTo: 16)) else {
            fatalError("Bad data \(CarDataMessage.self)")
        };
        
        return self.init(position: pos, direction: dir);
    }
    
    override func toData() -> Data {
        var data = position.data;
        data.append(direction.data);
        data.insert(type.rawValue, at: 0);
        return data;
    }
}
