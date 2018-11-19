//
//  SubmitScoreViewController.swift
//  Peer-to-Peer Remote Car Racing
//
//  Created by user145437 on 11/19/18.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import UIKit

class SubmitScoreViewController: UIViewController {


    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didMove(toParent parent: UIViewController?) {
        
    }
    

    @IBAction func close(_ sender: UIButton) {
        self.willMove(toParent: nil);
        view.removeFromSuperview();
        self.removeFromParent()
    }
}
