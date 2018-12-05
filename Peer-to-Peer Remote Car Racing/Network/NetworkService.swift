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


//Allows sending messages to peers connected through an MCSession
class NetworkService : NSObject {
    
    var delegate : NetworkServiceDelegate?;
    
    //Name used to let the service browser find the advertiser
    //They must both use same serviceType
    public static let serviceType = "p2premoteracing"
    //The name of the iphone
    //Used when displaying advertiser in the browser list
    public static let myPeerId = MCPeerID(displayName: UIDevice.current.name);
    
    //The session used to communicate over the network
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
    
    //Send a simple 1 byte MessageType to the peer
    func send(messageType: MessageType){
        assert(messageType.isSimpleMessageType());
        send(message: MessageBase(type: messageType));
    }
    
    //Send the input control to a peer
    //This is used by Controller in ControllerNetworkService
    func sendInputControl(inputControl: InputControl) {
        
        struct LastSent {
            static var velocity: CGPoint = CGPoint(x:0, y: 0);
        }
        //Only send messages if they are different from the last message
        //sent. This saves network bandwidth.
        if inputControl.velocity != LastSent.velocity {
            send(message: InputControlMessage(inputControl: inputControl), with: .unreliable)
        }
        LastSent.velocity = inputControl.velocity;
    }
    
    //Send the car position and rotation
    //This is used by Display in HostNetworkService
    func sendCarData(position: CGPoint, angle: CGFloat) {
        struct LastSent {
            static var position = CGPoint(x:0, y: 0);
            static var angle = CGFloat(0);
        }
        //Only send messages if they are different from the last message
        //sent. This saves network bandwidth.
        if position != LastSent.position || angle != LastSent.angle {
           send(message: CarDataMessage(position: position, angle: angle));
        }
        LastSent.position = position;
        LastSent.angle = angle;
    }
    
    //Send the message that a race finished with the time required to finish race
    func sendRaceFinished(time: Double) {
        send(message: RaceFinishedMessage(time: time));
    }
    
    //Converts messages conforming to the MessageBase protocol to Data objects
    //and sends it over network
    func send(message: MessageBase, with mode: MCSessionSendDataMode = .reliable){
        os_log("send %@", log: networkLog, type: .debug, message.description);
        send(data: message.toData(), with: mode );
    }
    
      //Sends the raw data to all peers connected in MCSession
    private func send(data: Data, with mode: MCSessionSendDataMode = .reliable ) {
        //Only send if peers are connected
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
    
        //If somehow we disconnected tell the delegate so it can respond
        DispatchQueue.main.async {
            if state == .notConnected {
                self.delegate?.handleMessage(message: MessageBase(type: .DISCONNECT));
            }
        }

    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let message = MessageFactory.decode(data: data);
        
        os_log("didReceiveData: %@", log: networkLog, type: .debug, message.description);
        
        //Disconnect from session if message told us to do so.
        if  message.type == .DISCONNECT {
            session.disconnect();
        }
        
        //Use the DispatchQueue to let delegate handle messages
        DispatchQueue.main.async {
            self.delegate?.handleMessage(message: message);
        }
        
    }
    
    //Unused but required for protocol
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        os_log("didReceiveStream", log: networkLog, type: .debug);
    }
    
    //Unused but required for protocol
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        os_log("didStartReceivingResourceWithName", log: networkLog, type: .debug);
    }
    
    //Unused but required for protocol
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        os_log("didFinishReceivingResourceWithName", log: networkLog, type: .debug);
    }
}

//Extension to make printing the MCSessionState to console easier
extension MCSessionState {
    func string() -> String {
        switch self {
        case .connected: return "connected"
        case .connecting: return "connecting"
        case .notConnected: return "notConnected"
        }
    }
}
