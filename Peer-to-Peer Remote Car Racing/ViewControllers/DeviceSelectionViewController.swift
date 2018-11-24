//
//  RemotePlayViewController.swift
//  Peer-to-PeerRemote Car Racing
//
//  Created by Joshua Ajakaiye on 2018-11-08.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class DeviceSelectionViewController: UIViewController, NetServiceDelegate {
    
    weak var networkService: NetworkService?;
    var alert: UIAlertController?;
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
 
    @IBAction func display(_ sender: UIButton) {
        SKTAudio.sharedInstance().playSoundEffect("button_press.wav")
        let hns = HostNetworkService();
        appDelegate.networkService = hns;
        networkService = hns;
        hns.delegate = self;
        
        alert = UIAlertController(title: "Waiting for Controller", message: "Please use another device and connect as controller.", preferredStyle: .alert);
        alert!.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            hns.serviceAdvertiser.stopAdvertisingPeer();
            hns.send(messageType: .DISCONNECT);
        }))
        self.present(alert!, animated:true, completion: nil);
    }
    
    @IBAction func controller(_ sender: UIButton) {
        SKTAudio.sharedInstance().playSoundEffect("button_press.wav")
        let cns = ControllerNetworkService();
        appDelegate.networkService = cns;
        networkService = cns;
        cns.delegate = self;
        let browser = MCBrowserViewController(browser: cns.serviceBrowser, session: cns.session);
        browser.delegate = self;
        browser.maximumNumberOfPeers = 2;
        browser.minimumNumberOfPeers = 2;
        present(browser, animated:true);
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
        SKTAudio.sharedInstance().playSoundEffect("button_press.wav")
    }
    
}

extension DeviceSelectionViewController: NetworkServiceDelegate {
    func handleMessage(message: MessageBase) {
        
        switch message.type {
        case .CONNECTED:
            alert?.dismiss(animated: true, completion: nil);
            if let trackSelectionViewController = storyboard?.instantiateViewController(withIdentifier: "TrackSelectionViewController") as? TrackSelectionViewController {
                trackSelectionViewController.gameMode = .DISPLAY;
                trackSelectionViewController.networkService = networkService;
                networkService?.delegate = trackSelectionViewController;
                navigationController?.pushViewController(trackSelectionViewController, animated: true);
                
            }
        case .DISCONNECT:
            if let ns = networkService as? HostNetworkService {
                ns.serviceAdvertiser.startAdvertisingPeer();
            }
            if ((networkService as? ControllerNetworkService) != nil) {
                //Do nothing
            }
        default:
            fatalError("Unexpected Network Message \(message.type)")
        }
    }
}

extension DeviceSelectionViewController : MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil);
        networkService?.send(messageType: .CONNECTED);
        if let trackSelectionViewController = storyboard?.instantiateViewController(withIdentifier: "TrackSelectionViewController") as? TrackSelectionViewController {
            trackSelectionViewController.gameMode = .CONTROLLER;
            trackSelectionViewController.networkService = networkService;
            networkService?.delegate = trackSelectionViewController;
            navigationController?.pushViewController(trackSelectionViewController, animated: true)
        }
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil);
        browserViewController.session.disconnect();
    }
}
