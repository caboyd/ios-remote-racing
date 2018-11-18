//
//  TrackSelectionViewController.swift
//  Peer-to-Peer Remote Car Racing
//
//  Created by user145437 on 11/16/18.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import UIKit

class TrackSelectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func start(_ sender: UIButton) {
        SKTAudio.sharedInstance().playSoundEffect("button_press.wav")
        if let gameViewController = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController {
            
            gameViewController.carType = "TODO";
            gameViewController.track = "Track1";
            
            navigationController?.pushViewController(gameViewController, animated: true)
        }
    }
    @IBAction func backButton(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
        SKTAudio.sharedInstance().playSoundEffect("button_press.wav")
    }
}
