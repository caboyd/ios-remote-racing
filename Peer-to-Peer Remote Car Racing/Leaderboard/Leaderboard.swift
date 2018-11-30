//
//  Leaderboard.swift
//  Peer-to-Peer Remote Car Racing
//
//  Created by Joshua Ajakaiye on 2018-11-30.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Leaderboard {
    
    var Name = [String]()
    var Score = [Double]()
    var ref:DatabaseReference = Database.database().reference()
    
    init(trackName: String, tableView : UITableView) {
        ref.child(trackName).observe(.childAdded, with: {(snapshot) in
            
            let data = snapshot.value as? NSDictionary
            
            if let actualScore = data? ["Score"] as? Double {
                self.Score.append(actualScore)
            }
            
            if let actualName = data? ["Name"] as? String {
                self.Name.append(actualName)
            }
            tableView.reloadData();
        })
        
    }
}
