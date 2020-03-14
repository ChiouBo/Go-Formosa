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
    
    func radian(inputDouble: Double) -> Double {
         return inputDouble * Double.pi/180.0
    }
    
    func markerView() -> UIImage {
        
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
