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

    var trackID: Int = TrackID.MIN
    var carID: Int = CarID.MIN;
    var carColor : CarColor = .black;
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var carImageParentView: UIView!
    @IBOutlet weak var carImage: UIImageView!
    
    @IBOutlet weak var startRaceButton: UIButton!
    @IBOutlet weak var prevCarButton: UIButton!
    @IBOutlet weak var nextCarButton: UIButton!
    @IBOutlet weak var prevTrackButton: UIButton!
    @IBOutlet weak var nextTrackButton: UIButton!
    @IBOutlet weak var changeColorButton: UIButton!
    var isDisplayDevice:Bool = false;
    weak var networkService: NetworkService?;
    
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
        
        if isDisplayDevice {
            hideButtons();
        }
    }
    

    func hideButtons() {
        changeColorButton.isHidden = true;
        startRaceButton.isHidden = true;
        prevCarButton.isHidden = true;
        nextCarButton.isHidden = true;
        prevTrackButton.isHidden = true;
        nextTrackButton.isHidden = true;
    }
    func updateTrackImage() {
        trackImage.image = UIImage(named: TrackID.toString(trackID).lowercased());
    
    }
    
    func updateCarImage() {
        let imageName = getCarTextureName(id: carID, color: carColor);
        carImage.image = UIImage(named: imageName);
    }
    
    func startSolo() {
    
    }
    
    func startDisplay(){
    
    }
    
    func startController(){
    
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func nextTrack(_ sender: UIButton?) {
        nextTrack();
        networkService?.send(messageType:  .TRACK_NEXT)
    }
    func nextTrack() {
        trackID = TrackID.getNextID(trackID);
        updateTrackImage();
    }
    @IBAction func prevTrack(_ sender: UIButton?) {
        prevTrack();
        networkService?.send(messageType: .TRACK_PREV)
    }
    func prevTrack() {
        
    }
    @IBAction func nextCar(_ sender: UIButton?) {
        nextCar();
        networkService?.send(messageType: .CAR_NEXT)
    }
    func nextCar(){
        carID = CarID.getNextID(carID);
        updateCarImage();
    }
    @IBAction func prevCar(_ sender: UIButton?) {
        prevCar();
        networkService?.send(messageType: .CAR_PREV)
    }
    func prevCar() {
        carID = CarID.getPreviousID(carID);
        updateCarImage();
    }
    @IBAction func nextCarColor(_ sender: UIButton?) {
        nextCarColor();
        networkService?.send(messageType: .CAR_COLOR)
    }
    func nextCarColor() {
        carColor.next();
        updateCarImage();
    }
    @IBAction func start(_ sender: UIButton) {
        networkService?.send(messageType: .NAV_START_RACE);
        SKTAudio.sharedInstance().playSoundEffect("button_press.wav")
        if let gameViewController = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController {
            
            gameViewController.carType = getCarTextureName(id: carID, color: carColor);
            gameViewController.track = TrackID.toString(trackID);
            
            navigationController?.pushViewController(gameViewController, animated: true)
        }
        
    }
    @IBAction func backButton(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
        SKTAudio.sharedInstance().playSoundEffect("button_press.wav")
        networkService?.send(messageType: .DISCONNECT);
    }
}


extension TrackSelectionViewController: NetworkServiceDelegate {
    func handleMessage(message: MessageBase) {
        
        switch message.type {
        case .CAR_NEXT:
            nextCar();
        case .CAR_PREV:
            prevCar();
        case .TRACK_NEXT:
            nextTrack();
        case .TRACK_PREV:
            prevTrack();
        case .CAR_COLOR:
            nextCarColor();
        case .NAV_START_RACE:
            startDisplay();
        case .DISCONNECT:
            _ = navigationController?.popViewController(animated: true)
        default:
            fatalError("Unexpected Network Message \(message.type)")
        }
    }
}
