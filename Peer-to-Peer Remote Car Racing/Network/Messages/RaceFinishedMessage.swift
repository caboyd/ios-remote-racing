//
//  RaceFinishedMessage.swift
//  Peer-to-Peer Remote Car Racing
//
//  Created by user145437 on 11/24/18.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import Foundation

class RaceFinishedMessage : MessageBase {
    var time: Double
    
    override var description : String {
        get {
            return "\(String(describing: type)) - time: \(time)"
        }
    }
    
    required init(time: Double) {
        self.time = time;
        super.init(type: .RACE_FINISHED)
    }
    
    override func toData() -> Data {
        var data = Data(from: Double.self);
        data.insert(type.rawValue, at: 0);
        return data;
    }
    
    static func from(data _data: Data) -> Self {
        let firstByte = _data[0];
        let data = _data.dropFirst()
        assert(MessageType(rawValue: firstByte) == .RACE_FINISHED);
        
        let time = data.to(type: Double.self);
        return self.init(time: time);
    }
}
