//
//  Leaderboard.swift
//  Peer-to-Peer Remote Car Racing
//
//  Created by Joshua Ajakaiye on 2018-11-30.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import Foundation
import FirebaseDatabase


class LeaderboardEntry {
    
    var Name: String;
    var Score: Double; //Time in seconds
    
    init(_ name : String, _ score : Double) {
        Name = name;
        Score = score;
    }
}

//Holds a list of LeaderboardEntries sorted by score asc.
class Leaderboard {
    
    var entries = [LeaderboardEntry]();
    var ref:DatabaseReference = Database.database().reference()
    
    init(trackName: String, tableView : UITableView) {
        //Quest top 10 scores
        let query = ref.child(trackName).queryOrdered(byChild: "Score").queryLimited(toFirst: 10);
        
        //Observe query so we are notified if any new scores are added while viewing
        query.observe(.childAdded, with: {(snapshot) in
            
            //Convert JSON data to NSDictionary
            let data = snapshot.value as? NSDictionary
            
            //Grab the name and score out of the dictionary if they exist
            if let score = data? ["Score"] as? Double,
                let name = data? ["Name"] as? String {
                
                //Create new entry
                let entry = LeaderboardEntry(name, score);
                
                //Put new entries in correct spot in array, sorted by scores asc
                if self.entries.count > 0 {
                    //Find index where all scores greater than new score
                    //If no index found then all scores are greater and we put entry at the end
                    let index = self.entries.index(where: { $0.Score > entry.Score }) ?? self.entries.count;
                    
                    //Insert at the found index
                    self.entries.insert(entry, at: index)
                } else {
                    //Empty array so just append entry
                    self.entries.append(entry);
                }
                
                //Update the view with new data
                tableView.reloadData();
            }
        })
    }
}
