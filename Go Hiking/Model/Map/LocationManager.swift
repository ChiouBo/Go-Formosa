//
//  LocationManager.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/15.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit
import CoreLocation

class LocationStepsManager: NSObject {
    
    private override init() {
        super.init()
    }
    
    public static let shared = LocationStepsManager()
    
    
    let locationManager = CLLocationManager()
    
//    fileprivate var locationSteps: [LocationStepCount] = []
    
//    fileprivate var currentLocation: CLLocationCoordinate2D? {
//
//        didSet {
//
//        }
//    }
    
//    fileprivate var currentStepCount: Int = 0
//
//    var storeThread: Thread?
//    var uploadThread: Thread?
//    var storeTimer: Timer?
//    var uploadTime: Timer?
//
//    fileprivate var isAllowWork: Bool = false
//
//    fileprivate let storeTimeInterval: TimeInterval = 120.0
//    fileprivate let uploadTimeInterval: TimeInterval = 120.0
    
//    fileprivate let disposeBag = DisposeBag()
//    fileprivate let uploadEvent = PublishSubject<UploadLoAndStepReq>()
    
//    fileprivate func startRecordLocation() {
//
//        locationManager.distanceFilter = 10
//        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//        locationManager.delegate = self
        
//        locationManager.requestAlwaysAuthorization()
//        locationManager.requestWhenInUseAuthorization()
//
//        locationManager.pausesLocationUpdatesAutomatically = false
//        locationManager.allowsBackgroundLocationUpdates = true
//
//        locationManager.startUpdatingLocation()
//        handleUploadEvent()
//    }
    
//    fileprivate func startWork() {
//
//        guard let coordinate = currentLocation else { return }
        
//        guard isInRange(coordinate: coordinate) else {
            
//            if isAllowWork {
                
        
//            }
//        }
//    }
    
    func radian(inputDouble: Double) -> Double {
         return inputDouble * Double.pi/180.0
    }
    
    func markerView() -> UIImage {

//        guard let marker = UIImage(named: "Icon_Map_RedDot")?.withRenderingMode(.alwaysTemplate) else { return UIImage() }
        
        let marker = UIImage()
        let markerView = UIImageView(image: marker)
        markerView.tintColor = UIColor.clear
        
        return marker
    }
    
    func getDistance(lat1: Double, lng1: Double, lat2: Double, lng2: Double) -> Double {
        
        let earthRadius: Double = 6378137.0
        
        let radLat1: Double = self.radian(inputDouble: lat1)
        let radLat2: Double = self.radian(inputDouble: lat2)
        let radLng1: Double = self.radian(inputDouble: lng1)
        let radLng2: Double = self.radian(inputDouble: lng2)
        
        let latDifference: Double = radLat1 - radLat2
        let longDifference: Double = radLng1 - radLng2
        var distance: Double = 2 * asin(sqrt(pow(sin(latDifference/2), 2) + cos(radLat1) * cos(radLat2) * pow(sin(longDifference/2), 2)))
        
        distance = (distance * earthRadius) / 1
        
       return distance
    }
}

