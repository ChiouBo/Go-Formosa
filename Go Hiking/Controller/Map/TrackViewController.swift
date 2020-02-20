//
//  TrackViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/20.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class TrackViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var trackMap: GMSMapView!
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var pauseBtn: UIButton!
    
    @IBOutlet weak var stopBtn: UIButton!
    
    let userLocationManager = CLLocationManager()
    
    var userPosition: CLLocationCoordinate2D?
    
    var currentPosition: [CLLocationCoordinate2D] = []
    
    var timer = Timer()
    var isTimerRunning = false
    var counter = 0.0
    
    var pause = false
    var stop = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        presentingViewController?.navigationController?.navigationBar.isHidden = true
        
        presentingViewController?.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        presentingViewController?.navigationController?.navigationBar.isHidden = false
               
        presentingViewController?.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTimer()
        
        setupBtns()
        
        getCurrentLocation()
        
        setUserLocationTrack()
        
        centerViewOnUserLocation()
    }
    
    
    
    @IBAction func pauseBtn(_ sender: UIButton) {
        
        pause = !pause
        
        if pause == true {
            pauseBtn.setImage(UIImage(named: "Icon_Map_Play"), for: .normal)
            isTimerRunning = false
            timer.invalidate()
            stopBtn.isHidden = false
        } else {
            pauseBtn.setImage(UIImage(named: "Icon_Map_Pause"), for: .normal)
            setTimer()
            stopBtn.isHidden = true
        }
    }
    
    @IBAction func stopBtn(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func setupBtns() {
        
        pauseBtn.setImage(UIImage(named: "Icon_Map_Pause"), for: .normal)
        pauseBtn.layer.cornerRadius = 50
        pauseBtn.layer.shadowOffset = CGSize(width: 2, height: 2)
        pauseBtn.layer.shadowOpacity = 0.7
        pauseBtn.layer.shadowRadius = 5
        pauseBtn.layer.shadowColor = UIColor.gray.cgColor
        
        stopBtn.setImage(UIImage(named: "Icon_Map_Stop"), for: .normal)
        stopBtn.layer.cornerRadius = 27
        stopBtn.layer.shadowOffset = CGSize(width: 2, height: 2)
        stopBtn.layer.shadowOpacity = 0.7
        stopBtn.layer.shadowRadius = 5
        stopBtn.layer.shadowColor = UIColor.gray.cgColor
    }
    
    func setTimer() {
        
        if !isTimerRunning {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
            isTimerRunning = true
        }
    }
    
    @objc func runTimer() {
        
        counter += 1
        timeLabel.text = "\(counter)"
        
        let flooredCounter = Int(floor(counter))
        let hour = flooredCounter / 3600
        
        let minute = (flooredCounter % 3600) / 60
        var minuteString = "\(minute)"
        if minute < 10 {
            minuteString = "0\(minute)"
        }
        
        let second = (flooredCounter % 3600) % 60
        var secondString = "\(second)"
        if second < 10 {
            secondString = "0\(second)"
        }
        
        timeLabel.text = "\(hour):\(minuteString):\(secondString)"
    }
    
    func getCurrentLocation() {
        
        trackMap.isMyLocationEnabled = true
        trackMap.settings.myLocationButton = true
        trackMap.settings.rotateGestures = false
        trackMap.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 64)
        
        if let mapStyleURL = Bundle.main.url(forResource: "MapDarkMode", withExtension: "json") {
            trackMap.mapStyle = try? GMSMapStyle(contentsOfFileURL: mapStyleURL)
        }
    }
    
    
    func setUserLocationTrack() {
        
        trackMap.delegate = self
        userLocationManager.delegate = self
        userLocationManager.startUpdatingLocation()
        userLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        userLocationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
    }
    
    func centerViewOnUserLocation() {
        
        guard let center = userLocationManager.location?.coordinate else { return }
        
        let myArrange = GMSCameraPosition.camera(withTarget: center, zoom: 18)
        
        trackMap.camera = myArrange
        userPosition = center
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: center.latitude, longitude: center.longitude)
        marker.map = trackMap
    }
    
}

extension TrackViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        guard let apple = userPosition else { return }
        
        let outCome = LocationStepsManager.shared.getDistance(lat1: apple.latitude, lng1: apple.longitude, lat2: position.target.latitude, lng2: position.target.longitude)
        
        print(position)
        
        if outCome > 0.00001 {
            
            self.userPosition = position.target
            self.currentPosition.append(position.target)
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: position.target.latitude, longitude: position.target.longitude)
            marker.title = "1"
            marker.map = trackMap
            
        } else {
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude, zoom: 18.0)
        self.trackMap.animate(to: camera)
        
        //    print("didUpdateLocations: \(location)")
        
        let marker = GMSMarker()
        marker.map = trackMap
    }
}
