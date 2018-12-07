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
    
    @IBOutlet weak var displayButton: UIButton!
    @IBOutlet weak var controllerButton: UIButton!
    weak var networkService: NetworkService?;
    var alert: UIAlertController?;
    override func viewDidLoad() {
        super.viewDidLoad()

        displayButton.imageView?.contentMode = .scaleAspectFit
        
        controllerButton.imageView?.contentMode  = .scaleAspectFit
    }
    
    // MARK: - Navigation
 
    //Display button pressed
    @IBAction func display(_ sender: UIButton) {
        SKTAudio.sharedInstance().playSoundEffect("button_press.wav")
        
        //Start advertising to peers
        let hns = DisplayNetworkService();
        appDelegate.networkService = hns;
        networkService = hns;
        hns.delegate = self;
        
        //Display Alert
        alert = UIAlertController(title: "Waiting for Controller", message: "Please use another device and connect as controller.", preferredStyle: .alert);
        alert!.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
            //stop the service Advertiser if cancel is pressed
            hns.serviceAdvertiser.stopAdvertisingPeer();
            hns.send(messageType: .DISCONNECT);
        }))
        self.present(alert!, animated:true, completion: nil);
    }
    
    //Controller button pressed
    @IBAction func controller(_ sender: UIButton) {
        SKTAudio.sharedInstance().playSoundEffect("button_press.wav")
        let cns = ControllerNetworkService();
        appDelegate.networkService = cns;
        networkService = cns;
        cns.delegate = self;
        
        //Open MCBrowserViewController
        let browser = MCBrowserViewController(browser: cns.serviceBrowser, session: cns.session);
        browser.delegate = self;
        browser.maximumNumberOfPeers = 2;
        browser.minimumNumberOfPeers = 2;
        present(browser, animated:true);
    }
    
    //Navigate back
    @IBAction func backButton(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
        SKTAudio.sharedInstance().playSoundEffect("button_press.wav")
    }
    
}

extension DeviceSelectionViewController: NetworkServiceDelegate {
    func handleMessage(message: MessageBase) {
        

        switch message.type {
        case .CONNECTED:
            //This message is only received by Display device
            //Dimiss alert after connected
            alert?.dismiss(animated: true, completion: nil);
            
            //Navigate to TrackSelectionViewController as Display gameMode
            if let trackSelectionViewController = storyboard?.instantiateViewController(withIdentifier: "TrackSelectionViewController") as? TrackSelectionViewController {
                trackSelectionViewController.gameMode = .DISPLAY;
                trackSelectionViewController.networkService = networkService;
                networkService?.delegate = trackSelectionViewController;
                navigationController?.pushViewController(trackSelectionViewController, animated: true);
                
            }
        case .DISCONNECT:
            if let ns = networkService as? DisplayNetworkService {
                ns.serviceAdvertiser.startAdvertisingPeer();
            }
        default:
            fatalError("Unexpected Network Message \(message.type)")
        }
    }
}


extension DeviceSelectionViewController : MCBrowserViewControllerDelegate {
    
    //When DONE button is pressed on the BrowserViewController
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil);
        //Notify display that it is connected
        networkService?.send(messageType: .CONNECTED);
        
        //Navigate to TrackSelectionViewController as Controller gameMode
        if let trackSelectionViewController = storyboard?.instantiateViewController(withIdentifier: "TrackSelectionViewController") as? TrackSelectionViewController {
            trackSelectionViewController.gameMode = .CONTROLLER;
            trackSelectionViewController.networkService = networkService;
            networkService?.delegate = trackSelectionViewController;
            navigationController?.pushViewController(trackSelectionViewController, animated: true)
        }
    }
    
    //Cancel pressed
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil);
        //Disconnect if connected
        browserViewController.session.disconnect();
    }
}
