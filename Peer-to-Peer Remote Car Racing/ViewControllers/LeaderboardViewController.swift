//
//  LeaderboardViewController.swift
//  Peer-to-Peer Remote Car Racing
//
//  Created by user145437 on 11/16/18.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController  {
    
    @IBOutlet weak var tabledScores: UITableView!
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var headerView: UIView!
    
    var trackID : Int = TrackID.MIN
    var leaderboards = [Leaderboard]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tabledScores.delegate = self
        tabledScores.dataSource = self
        
        //Add grey round border
        trackImage.layer.cornerRadius = 10;
        trackImage.layer.borderColor = UIColor.gray.cgColor;
        trackImage.layer.borderWidth = 3;
        
        //Create the two leaderboards with data from Firebase
        leaderboards.append(Leaderboard(trackName: "Track1", tableView: tabledScores));
        leaderboards.append(Leaderboard(trackName: "Track2", tableView: tabledScores));
        
        //Add rounded cornerd
        tabledScores.layer.cornerRadius = 15;
        headerView.layer.cornerRadius = 15;
    }
    
    //Navigate back
    @IBAction func backButton(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
        SKTAudio.sharedInstance().playSoundEffect("button_press.wav")
    }
    
    
    @IBAction func nextTrack(_ sender: UIButton?) {
        SKTAudio.sharedInstance().playSoundEffect("button_press.wav")
        trackID = TrackID.getNextID(trackID);
        updateTrackImage();
        tabledScores.reloadData();
    }
    
    @IBAction func prevTrack(_ sender: UIButton?) {
        SKTAudio.sharedInstance().playSoundEffect("button_press.wav")
        trackID = TrackID.getPreviousID(trackID);
        updateTrackImage();
        tabledScores.reloadData();
    }
    
    func updateTrackImage() {
        trackImage.image = UIImage(named: TrackID.toString(trackID).lowercased());
    }
    

    
}

extension LeaderboardViewController :UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         //Number of rows is the amount if entries in the leaderboard
        return leaderboards[trackID - 1].entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //get correct leaderboard
        let leaderboard = leaderboards[trackID - 1];
        //get the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardTableViewCell") as? LeaderboardTableViewCell
        //convert score from double to string
        let timeAsString = stringFromTimeInterval(interval: leaderboard.entries[indexPath.row].Score) as String
        
        cell?.nameLabel?.text = "\(leaderboard.entries[indexPath.row].Name)"
        cell?.scoreLabel?.text = "\(timeAsString)"
        //Rank is the row in the table + 1
        cell?.rankLabel?.text = "\(indexPath.row + 1)"
        
        return cell!
    }

}
