//
//  TrackSelectionViewController.swift
//  Peer-to-Peer Remote Car Racing
//
//  Created by user145437 on 11/16/18.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import UIKit
import SpriteKit

class TrackSelectionViewController: UIViewController {

    var track:String = "Track1";
    var carID: Int = CarID.minCarID;
    var carColor : CarColor = .black;
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var carImageParentView: UIView!
    @IBOutlet weak var carImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        trackImage.layer.cornerRadius = 10;
        trackImage.layer.borderColor = UIColor.gray.cgColor;
        trackImage.layer.borderWidth = 3;
        
        carImageParentView.layer.cornerRadius = 10;
        carImageParentView.layer.borderColor = UIColor.gray.cgColor;
        carImageParentView.layer.borderWidth = 3;
        
        updateTrackImage();
        updateCarImage();
    }
    

    func updateTrackImage() {
        trackImage.image = UIImage(named: track.lowercased());
    }
    
    func updateCarImage() {
        let imageName = getCarTextureName(id: carID, color: carColor);
        carImage.image = UIImage(named: imageName);
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func nextCar(_ sender: UIButton) {
        carID = CarID.getNextID(carID);
        updateCarImage();
    }
    @IBAction func prevCar(_ sender: UIButton) {
        carID = CarID.getPreviousID(carID);
        updateCarImage();
    }
    
    @IBAction func nextCarColor(_ sender: UIButton) {
        carColor.next();
        updateCarImage();
    }
    
    @IBAction func start(_ sender: UIButton) {
        SKTAudio.sharedInstance().playSoundEffect("button_press.wav")
        if let gameViewController = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController {
            
            gameViewController.carType = getCarTextureName(id: carID, color: carColor);
            gameViewController.track = "Track1";
            
            navigationController?.pushViewController(gameViewController, animated: true)
        }
    }
    @IBAction func backButton(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
        SKTAudio.sharedInstance().playSoundEffect("button_press.wav")
    }
}
