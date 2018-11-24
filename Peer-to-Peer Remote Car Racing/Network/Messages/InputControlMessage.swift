//
//  InputControlMessage.swift
//  Peer-to-Peer Remote Car Racing
//
//  Created by user145437 on 11/24/18.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import Foundation
import CoreGraphics

class InputControlMessage : MessageBase {
    var velocity: CGPoint
    
    required init(velocity: CGPoint) {
        self.velocity = velocity;
        super.init(type: .INPUT_CONTROL);
        
    }
    
    convenience init(inputControl: InputControl) {
        self.init(velocity: inputControl.velocity);
    }
    
    static func from(data _data: Data) -> Self {
        let firstByte = _data[0];
        let data = _data.dropFirst();
        assert(MessageType(rawValue: firstByte) == .INPUT_CONTROL);
        guard let velocity = CGPoint(data: data) else {
            fatalError("Bad \(InputControlMessage.self)");
        }
        return self.init(velocity: velocity);
    }
    
    override func toData() -> Data {
        var data = velocity.data;
        data.insert(type.rawValue, at: 0);
        return data;
    }
}
