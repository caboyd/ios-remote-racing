//
//  OptionsViewController.swift
//  Peer-to-Peer Remote Car Racing
//
//  Created by Christopher Boyd on 2018-12-01.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Update segmentControl with value saved in user defauls
        let buttons = UserDefaults.standard.integer(forKey: "ControlType")
        segmentControl.selectedSegmentIndex = buttons;
        
        //Increase font size of segment control because it can't be done in the storyboard
        let font: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24)]
        segmentControl.setTitleTextAttributes(font, for: .normal)
    }
    
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        //Save Control Type in user settings
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "ControlType")
    }
    
    //Navigate to previous View Controller
    @IBAction func back(_ sender: UIButton) {
        SKTAudio.sharedInstance().playSoundEffect("button_press.wav");
        _ = navigationController?.popViewController(animated: true)
    }
}
