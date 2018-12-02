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
    var Score: Double;
    
    init(_ name : String, _ score : Double) {
        Name = name;
        Score = score;
    }
}

class Leaderboard {
    
    var entries = [LeaderboardEntry]();
    var ref:DatabaseReference = Database.database().reference()
    
    init(trackName: String, tableView : UITableView) {
        let query = ref.child(trackName).queryOrdered(byChild: "Score").queryLimited(toFirst: 10);
        query.observe(.childAdded, with: {(snapshot) in
            
            let data = snapshot.value as? NSDictionary
            
            if let actualScore = data? ["Score"] as? Double,
                let actualName = data? ["Name"] as? String {
                
                let entry = LeaderboardEntry(actualName, actualScore);
                
                //Put new entries in correct spot in array, sorted by scores asc
                if self.entries.count > 0 {
                    let index = self.entries.index(where: { $0.Score > entry.Score }) ?? self.entries.count;
                    self.entries.insert(entry, at: index)
                    
                } else {
                    self.entries.append(entry);
                }
                
                tableView.reloadData();
            }
            

        })
        
    }

}
