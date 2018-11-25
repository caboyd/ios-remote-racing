//
//  ControllerNetworkService.swift
//  multipeer test
//
//  Created by user145437 on 11/9/18.
//  Copyright © 2018 Christopher Boyd. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import os.log

class ControllerNetworkService : NetworkService {
    public var serviceBrowser: MCNearbyServiceBrowser;
    
    
    override init(){
        self.serviceBrowser = MCNearbyServiceBrowser(peer: NetworkService.myPeerId, serviceType: NetworkService.serviceType)
        super.init()
    
        //self.serviceBrowser.delegate = self;
        //self.serviceBrowser.startBrowsingForPeers();
    }
    
    deinit{
        self.serviceBrowser.stopBrowsingForPeers();
    }
}

extension ControllerNetworkService : MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        os_log("didNotStartBrowsingForPeers: %s", log: networkLog, type: .debug, error.localizedDescription)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        os_log("foundPeer: %@", log: networkLog, type: .debug, peerID);
       // os_log("invitePeer: %@", log: networkLog, type: .debug, peerID);
       // browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10);
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        os_log("lostPeer: %@", log: networkLog, type: .debug, peerID);
    }
}
