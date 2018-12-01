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
    
    var trackID : Int = TrackID.MIN
    var leaderboards = [Leaderboard]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tabledScores.delegate = self
        tabledScores.dataSource = self
        
        leaderboards.append(Leaderboard(trackName: "Track1", tableView: tabledScores));
        leaderboards.append(Leaderboard(trackName: "Track2", tableView: tabledScores));
        
        tabledScores.layer.cornerRadius = 15;
        tabledScores.sectionHeaderHeight = 40;
    }
    

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
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView();
        let headerCell = tabledScores.dequeueReusableCell(withIdentifier: "Header")!;
        headerView.addSubview(headerCell);
        return headerView;
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
        cell?.nameLabel?.text = "\(leaderboard.Name[indexPath.row])"
        cell?.scoreLabel?.text = "\(space)"
        cell?.rankLabel?.text = "\(indexPath.row + 1)"
        
        return cell!
    }

}
