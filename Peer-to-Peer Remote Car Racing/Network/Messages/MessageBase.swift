//
//  MessageBase.swift
//  Peer-to-Peer Remote Car Racing
//
//  Created by user145437 on 11/23/18.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import Foundation
import CoreGraphics

enum MessageType : UInt8 {
    //simple 1 byte messages
    case CONNECTED
    case DISCONNECT
    case NAV_START_RACE
    case NAV_TRACK_SELECT
    
    case PAUSE
    case RESUME
    case RESTART
    case CAR_NEXT
    case CAR_PREV
    case CAR_COLOR
    case TRACK_NEXT
    case TRACK_PREV
    case LAP_FINISHED
    
    //messages with data
    //one CGVector
    case INPUT_CONTROL
    
    //two CGVector
    case CAR_DATA
    
    //one Double for time
    case RACE_FINISHED
    
    func toData() -> Data {
        if isSimpleMessageType() {
            return Data(from: self.rawValue);
        } else {
            fatalError("Cannot convert advanced message types to data. Use their classes.")
        }
    }
    
    
    func isSimpleMessageType() -> Bool {
        return self != MessageType.INPUT_CONTROL &&
        self != MessageType.CAR_DATA &&
            self != MessageType.RACE_FINISHED
                
        
    }
}


class MessageBase {
    var type : MessageType;
    
    init(type: MessageType) {
        self.type = type;
    }
    
    func toData() -> Data {
        return type.toData();
    }
    
}




class MessageFactory {
    static func decode(data: Data) -> MessageBase {
        
        //DOES THIS WORK FOR ALL CASES
        //return MessageBase.from(data: data);
        
        
        assert(data.count > 0)
        let messageType = MessageType(rawValue: data[0])!;
        
        if messageType.isSimpleMessageType() {
            return MessageBase(type: messageType);
        }
        
        switch messageType {
        case .INPUT_CONTROL:
            return InputControlMessage.from(data: data);
        case .CAR_DATA:
            return CarDataMessage.from(data: data);
        default:
            fatalError()
        }
    }
}



//Data conversion helpers
extension Data {
    
    init<T>(from value: T) {
        self = Swift.withUnsafeBytes(of: value) { Data($0) }
    }
    
    init<T>(fromArray values: [T]) {
        self = values.withUnsafeBytes { Data($0) }
    }
    
    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.pointee }
    }
    
    func toArray<T>(type: T.Type) -> [T] {
        return self.withUnsafeBytes {
            [T](UnsafeBufferPointer(start: $0, count: self.count/MemoryLayout<T>.stride))
        }
    }
}

protocol DataConvertible {
    init?(data:Data)
    var data: Data { get }
}

extension DataConvertible {
    init?(data: Data){
        guard data.count == MemoryLayout<Self>.size else { return nil }
        self = data.withUnsafeBytes { $0.pointee }
    }
    
    var data: Data {
        return withUnsafeBytes(of: self) { Data($0) }
    }
}

extension CGPoint : DataConvertible {}
