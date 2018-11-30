//
//  LeaderboardViewController.swift
//  Peer-to-Peer Remote Car Racing
//
//  Created by user145437 on 11/16/18.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import UIKit
import FirebaseDatabase

class LeaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tabledScores: UITableView!
    
    var trackID : Int = TrackID.MIN
    var leaderboards = [Leaderboard]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tabledScores.delegate = self
        tabledScores.dataSource = self
        
        leaderboards.append(Leaderboard(trackName: "Track1", tableView: tabledScores));
        leaderboards.append(Leaderboard(trackName: "Track2", tableView: tabledScores));
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func backButton(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
        SKTAudio.sharedInstance().playSoundEffect("button_press.wav")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboards[trackID - 1].Name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let leaderboard = leaderboards[trackID - 1];
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardTableViewCell") as? LeaderboardTableViewCell
        let space = stringFromTimeInterval(interval: leaderboard.Score[indexPath.row]) as String
        cell?.nameLabel?.text = "\(leaderboard.Name[indexPath.row])\(space)"
        
        return cell!
    }
    
}
