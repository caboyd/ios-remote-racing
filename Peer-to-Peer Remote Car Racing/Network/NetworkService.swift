//
//  NetworkService.swift
//  multipeer test
//
//  Created by Christopher Boyd on 2018-11-08.
//  Copyright © 2018 Christopher Boyd. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import os.log

let networkLog = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "Network Service")

protocol NetworkServiceDelegate {
    func handleMessage(message: MessageBase);
}


class NetworkService : NSObject {
    
    var delegate : NetworkServiceDelegate?;
    
    public static let serviceType = "p2premoteracing"
    public static let myPeerId = MCPeerID(displayName: UIDevice.current.name);
    
    public lazy var session: MCSession = {
        let session = MCSession(peer: NetworkService.myPeerId, securityIdentity: nil, encryptionPreference: .required);
        session.delegate = self;
        return session;
    }();
    
    override init() {
        super.init();
    }
    
    deinit{
    }
    
    func send(messageType: MessageType){
        send(data: messageType.toData());
    }
    
    func sendInputControl(inputControl: InputControl) {
        struct LastSent {
            static var velocity: CGPoint = CGPoint(x:0, y: 0);
        }
        if inputControl.velocity != LastSent.velocity {
            send(data: InputControlMessage(inputControl: inputControl).toData(), with: .unreliable)
        }
        LastSent.velocity = inputControl.velocity;
    }
    
    func sendCarData(position: CGPoint, angle: CGFloat) {
        struct LastSent {
            static var position = CGPoint(x:0, y: 0);
            static var angle = CGFloat(0);
        }

        if position != LastSent.position || angle != LastSent.angle {
           send(data: CarDataMessage(position: position, angle: angle).toData());
        }
        LastSent.position = position;
        LastSent.angle = angle;
    }
    
    func sendRaceFinished(time: Double) {
        send(data: RaceFinishedMessage(time: time).toData());
    }
    
    private func send(data: Data, with mode: MCSessionSendDataMode = .reliable ) {
        if session.connectedPeers.count > 0 {
            do {
                try self.session.send(data, toPeers: session.connectedPeers, with: mode)
            }
            catch let error {
                os_log("Error for sending %@", log: networkLog, type: .debug, error.localizedDescription);
            }
        }
    }
}



extension NetworkService : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        os_log("peer %@ didChangeState: %s", log: networkLog, type: .debug, peerID, state.string());
        
        DispatchQueue.main.async {
            if state == .notConnected {
                self.delegate?.handleMessage(message: MessageBase(type: .DISCONNECT));
            }
        }

    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let message = MessageFactory.decode(data: data);
        
        os_log("didReceiveData: %@", log: networkLog, type: .debug, message.description);
        
        
        if  message.type == .DISCONNECT {
            session.disconnect();
        }
        
        
        DispatchQueue.main.async {
            
            self.delegate?.handleMessage(message: message);
        }
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        os_log("didReceiveStream", log: networkLog, type: .debug);
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        os_log("didStartReceivingResourceWithName", log: networkLog, type: .debug);
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        os_log("didFinishReceivingResourceWithName", log: networkLog, type: .debug);
    }
}

extension MCSessionState {
    func string() -> String {
        switch self {
        case .connected: return "connected"
        case .connecting: return "connecting"
        case .notConnected: return "notConnected"
        }
    }
}
