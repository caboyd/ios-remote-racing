//
//  SubmitScoreViewController.swift
//  Peer-to-Peer Remote Car Racing
//
//  Created by user145437 on 11/19/18.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import UIKit

class SubmitScoreViewController: UIViewController {


    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var time: TimeInterval!;
    var trackName: String!;
    var closeCallback: (() -> Void)?;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //try to get name from user defaults
        nameTextField.delegate = self;
        nameTextField.text = UserDefaults.standard.string(forKey: "name") ?? "";
        
        updateSubmitButtonState();
    }
    
    override func didMove(toParent parent: UIViewController?) {
        timeLabel.text = stringFromTimeInterval(interval: time) as String;
        
        //TODO: get rank from firebase leaderboard
        rankLabel.text = "\(999)";
    }
    

    @IBAction func submit(_ sender: UIButton) {
        SubmitScoreViewController.saveBestScoreLocally(trackName: trackName, score: time)
        let name = nameTextField.text ?? "";
        UserDefaults.standard.set(name, forKey: "name");
        
        //TODO: submit to firebase
    }
    
    
    @IBAction func close(_ sender: UIButton) {
        closeCallback?();
        self.willMove(toParent: nil);
        view.removeFromSuperview();
        self.removeFromParent()
    }
    
    private func updateSubmitButtonState() {
        let text = nameTextField.text ?? "";
        submitButton.isEnabled = !text.isEmpty;
    }
    
    static func saveBestScoreLocally(trackName: String, score : TimeInterval) {
        UserDefaults.standard.set(score, forKey: trackName)
    }
    
    static func loadBestScoreLocally(trackName : String) -> TimeInterval? {
        return UserDefaults.standard.double(forKey: trackName);
    }
}


extension SubmitScoreViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        submitButton.isEnabled = false;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSubmitButtonState();
    }
}
