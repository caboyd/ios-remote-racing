//
//  SubmitScoreViewController.swift
//  Peer-to-Peer Remote Car Racing
//
//  Created by user145437 on 11/19/18.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import UIKit

class SubmitScoreViewController: UIViewController {


    
    @IBOutlet weak var timeLabel: UILabel!
    var time: TimeInterval!;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didMove(toParent parent: UIViewController?) {
        timeLabel.text = stringFromTimeInterval(interval: time) as String;
        
        //TODO: submit score to firebase leaderboard
    }
    

    @IBAction func close(_ sender: UIButton) {
        self.willMove(toParent: nil);
        view.removeFromSuperview();
        self.removeFromParent()
    }
    
    static func saveBestScoreLocally(trackName: String, score : TimeInterval) {
        UserDefaults.standard.set(score, forKey: trackName)
    }
    
    static func loadBestScoreLocally(trackName : String) -> TimeInterval? {
        return UserDefaults.standard.double(forKey: trackName);
    }
}
