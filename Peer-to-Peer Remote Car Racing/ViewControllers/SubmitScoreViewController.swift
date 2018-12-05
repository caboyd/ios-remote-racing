//
//  SubmitScoreViewController.swift
//  Peer-to-Peer Remote Car Racing
//
//  Created by user145437 on 11/19/18.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SubmitScoreViewController: UIViewController {


    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var time: TimeInterval = 0;
    var trackName: String = "Track1";
    var closeCallback: (() -> Void) = {};
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //The firebase database
        ref = Database.database().reference()

        nameTextField.delegate = self;
        
        //Update name label with value saved in user defaults
        nameTextField.text = UserDefaults.standard.string(forKey: "name") ?? "";
        
        updateSubmitButtonState();
    }
    
    override func didMove(toParent parent: UIViewController?) {
        //Update time label with value set by game view controller
        timeLabel.text = stringFromTimeInterval(interval: time) as String;
    
        //Query all scores that are faster than this time
        let query = ref?.child(trackName).queryOrdered(byChild: "Score").queryEnding(atValue: time, childKey: "Score")
        query?.observeSingleEvent(of: .value, with: { (snapshot) in
            //Set the rank label to the count + 1
            self.rankLabel.text = "\(snapshot.childrenCount+1)"
        })
       ;
    }
    

    @IBAction func submit(_ sender: UIButton) {
        let name = nameTextField.text ?? "";
        UserDefaults.standard.set(name, forKey: "name");
        
        //Insert new score into firebase database
        ref?.child(trackName).childByAutoId().setValue(["Name":name, "Score":time])
        
        //dismiss the popup view
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func close(_ sender: UIButton) {
        
        //This callback is used to re-enable buttons that
        //were disabled in the previous view.
        //They were disabled so that they are not clickable
        //through this view.
        closeCallback();
        
        self.willMove(toParent: nil);
        view.removeFromSuperview();
        self.removeFromParent()
        
        //dismiss the popup view
        presentingViewController?.dismiss(animated: true, completion: nil)
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
