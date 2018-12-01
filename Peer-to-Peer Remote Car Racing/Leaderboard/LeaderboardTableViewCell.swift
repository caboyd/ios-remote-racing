//
//  LeaderboardTableViewCell.swift
//  Peer-to-Peer Remote Car Racing
//
//  Created by Joshua Ajakaiye on 2018-11-30.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import UIKit

class LeaderboardTableViewCell: UITableViewCell {

    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
