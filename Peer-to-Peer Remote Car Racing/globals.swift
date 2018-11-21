//
//  globals.swift
//  Peer-to-Peer Remote Car Racing
//
//  Created by user145437 on 11/19/18.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import Foundation
import SpriteKit


var displaySize: CGRect = UIScreen.main.bounds {
    didSet {
        displayAspect = displaySize.width / displaySize.height;
    }
};
var displayAspect = displaySize.width / displaySize.height;


//test
