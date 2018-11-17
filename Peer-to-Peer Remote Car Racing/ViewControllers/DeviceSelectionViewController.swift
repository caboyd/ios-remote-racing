//
//  RemotePlayViewController.swift
//  Peer-to-PeerRemote Car Racing
//
//  Created by Joshua Ajakaiye on 2018-11-08.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import UIKit

class DeviceSelectionViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
 
    @IBAction func backButton(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
        SKTAudio.sharedInstance().playSoundEffect("button_press.wav")
    }
}
