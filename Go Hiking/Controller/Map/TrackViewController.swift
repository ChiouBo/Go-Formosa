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
import Firebase
import FirebaseStorage
import FirebaseDatabase

struct histroy {
    
    let lat: Double
    let long: Double
    
    var toDict: [String: Any] {
        
        return [
            "lat": lat,
            "long": long
        ]
    }
}

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
    
    var pathLine: [[String: Any]] = []
    
    var pathLat: [Double] = []
    
    var pathLong: [Double] = []
    
    var path = GMSMutablePath()
    
    var date = ""
    
    var timer = Timer()
    
    var isTimerRunning = false
    
    var counter = 0.0
    
    var distance = 0.00
    
    var pause = false
    
    var stop = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        presentingViewController?.navigationController?.navigationBar.isHidden = true
        
        presentingViewController?.tabBarController?.tabBar.isHidden = true
        
        var bounds: GMSCoordinateBounds = GMSCoordinateBounds()
        for index in 0 ..< path.count() {
            bounds = bounds.includingCoordinate(path.coordinate(at: index))
        }
        self.trackMap.animate(with: GMSCameraUpdate.fit(bounds))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        presentingViewController?.navigationController?.navigationBar.isHidden = false
        
        presentingViewController?.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateToday()
        
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
        
        guard let id = Auth.auth().currentUser?.uid,
            let distance = distanceLabel.text,
            let time = timeLabel.text else { return }
        
        guard let sumDistance = Double(distance) else { return }
        
            let path = UserRecord(id: id, date: date, distance: sumDistance, time: time, markerLat: pathLat, markerLong: pathLong, lineImage: "")
            
            LKProgressHUD.showWaitingList(text: "路徑紀錄中..", viewController: self)
            
            LKProgressHUD.showSuccess(text: "紀錄完成", viewController: self)
            
            UserManager.share.saveRecordData(userRecord: path) { (result) in
                
                switch result {
                    
                case .success(let data):
                    print(data)
                    
                case .failure(let error):
                    print(error)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    
    func dateToday() {
        
        let today = Date()
        let timeInterval = TimeInterval(today.timeIntervalSince1970)
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/ MM/ dd"
        let nowDay = dateFormatter.string(from: date)
        self.date = nowDay
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
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
                
                guard let cord = self.userLocationManager.location?.coordinate,
                    let userPosition = self.userPosition else { return }
                
                let outCome = LocationStepsManager.shared.getDistance(lat1: userPosition.latitude, lng1: userPosition.longitude, lat2: cord.latitude, lng2: cord.longitude)
                
                print(outCome)
                
                if outCome > 0.0001 {
                    
                    self.userPosition = cord
                    
                    self.currentPosition.append(cord)
                    
                    let marker = GMSMarker()
                    
                    marker.position = CLLocationCoordinate2D(latitude: cord.latitude, longitude: cord.longitude)
                    
                    marker.icon = LocationStepsManager.shared.markerView()
                    marker.map = self.trackMap
                    
                    self.path.add(CLLocationCoordinate2D(latitude: userPosition.latitude, longitude: userPosition.longitude))
                    self.path.add(CLLocationCoordinate2D(latitude: cord.latitude, longitude: cord.longitude))
                    
                    self.pathLat.append(cord.latitude)
                    self.pathLong.append(cord.longitude)
                    
                    print(self.pathLine)
                    
                    let line = GMSPolyline(path: self.path)
                    line.strokeWidth = 10
                    line.strokeColor = .white
                    line.geodesic = true
                    let redYellow =
                        GMSStrokeStyle.gradient(from: .red, to: .yellow)
                    let yellowRed = GMSStrokeStyle.gradient(from: .yellow, to: .red)
                    line.spans = [GMSStyleSpan(style: redYellow),
                                  GMSStyleSpan(style: redYellow),
                                  GMSStyleSpan(style: yellowRed)]
                    
                    line.map = self.trackMap
                    
                    self.distance += Double(Int(outCome)) / 1000
                    let setDistance = String(format: "%.2f", self.distance)
                    self.distanceLabel.text = "\(setDistance)"
                    print(self.distanceLabel.text ?? "")
                    
                } else {
                    return
                }
            }
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
        
        trackMap.delegate = self
        userLocationManager.delegate = self
        userLocationManager.startUpdatingLocation()
        trackMap.isMyLocationEnabled = true
        trackMap.settings.myLocationButton = true
        trackMap.settings.rotateGestures = false
        trackMap.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 64)
        
        guard let location = userLocationManager.location?.coordinate else { return }
        
        pathLat.append(location.latitude)
        pathLong.append(location.longitude)
        
//        let origin = histroy(lat: location.latitude, long: location.longitude)
//        pathLine.append(origin.toDict)
        
        
        if let mapStyleURL = Bundle.main.url(forResource: "MapDarkMode", withExtension: "json") {
            trackMap.mapStyle = try? GMSMapStyle(contentsOfFileURL: mapStyleURL)
        }
    }
    
    
    func setUserLocationTrack() {
        
        userLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        userLocationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        userLocationManager.allowsBackgroundLocationUpdates = true
        userLocationManager.pausesLocationUpdatesAutomatically = false
        userLocationManager.requestAlwaysAuthorization()
    }
    
    func centerViewOnUserLocation() {
        
        guard let center = userLocationManager.location?.coordinate else { return }
        
        let myArrange = GMSCameraPosition.camera(withTarget: center, zoom: 18.0)
        
        trackMap.camera = myArrange
        userPosition = center
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: center.latitude, longitude: center.longitude)
        marker.map = trackMap
    }
    
}

extension TrackViewController: GMSMapViewDelegate {
    
}
