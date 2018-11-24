//
//  HostNetworkService.swift
//  multipeer test
//
//  Created by user145437 on 11/9/18.
//  Copyright © 2018 Christopher Boyd. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import os.log

class HostNetworkService : NetworkService {
    
    public let serviceAdvertiser : MCNearbyServiceAdvertiser;

    override init(){
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: NetworkService.myPeerId, discoveryInfo: nil, serviceType: NetworkService.serviceType)
        super.init();
        
        self.serviceAdvertiser.delegate = self;
        self.serviceAdvertiser.startAdvertisingPeer()
    }
    
    deinit{
        self.serviceAdvertiser.stopAdvertisingPeer();
    }
}

extension HostNetworkService : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        os_log("didNotStartAdvertisingPeer: %s", log: networkLog, type: .debug, error.localizedDescription );
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        os_log("didReceiveInvitationFromPeer %@", log: networkLog, type: .debug, peerID);
        
        invitationHandler(true, self.session);
    }
    
}
