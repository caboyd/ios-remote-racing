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
    var angle: CGFloat
    
    override var description : String {
        get {
            return "\(String(describing: type)) - position: \(position), angle: \(angle)"
        }
    }
    
    required init(position: CGPoint, angle: CGFloat) {
        self.position = position;
        self.angle = angle;
        super.init(type: .CAR_DATA);
        
    }
    
    static func from(data _data: Data) -> Self {
        let firstByte = _data[0];
        assert(MessageType(rawValue: firstByte) == .CAR_DATA);
        let d1 = _data[1..<17];
        let d2 = _data[17..<25];
        guard let pos =  CGPoint(data: d1) else {
            fatalError("Bad data \(CarDataMessage.self)")
        };
        let angle = d2.to(type: CGFloat.self);
        
        return self.init(position: pos, angle: angle);
    }
    
    override func toData() -> Data {
        var data = position.data;
        data.append(Data(from: angle));
        data.insert(type.rawValue, at: 0);
        return data;
    }
}
