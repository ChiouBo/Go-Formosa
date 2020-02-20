//
//  MapViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/1/30.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GoogleMapsBase
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, UISearchDisplayDelegate {
    
    @IBOutlet weak var fadeOutView: UIView!
    
    var path: GMSMutablePath!
    
    var userLocationManager = CLLocationManager()
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    
    var searchController: UISearchController?
    
    var resultView: UITextView?
    
    var searchBar: UISearchBar?
    
    var tableDataSource: GMSAutocompleteTableDataSource?
    
    //Marker Path
    var userLocation: [CLLocationCoordinate2D] = []
    
    var currentPosition: CLLocationCoordinate2D?
    
    
    @IBOutlet weak var googleMapView: GMSMapView!
    
    @IBOutlet weak var startExplore: UIButton!
    
    @IBOutlet weak var mapSetting: UIButton!
    
    @IBAction func startExplore(_ sender: UIButton) {
        
//        setAlert()
//        keepTrackUserLocation()
//        trackingUserLocation()
//
//        guard let location = userLocationManager.location?.coordinate else { return }
//
//        currentPosition = location
//
//        setTimer()
        if self.fadeOutView.alpha == 0.0 {
            
            UIView.animate(withDuration: 1, delay: 0.1, options: .curveEaseOut, animations: {
                self.fadeOutView.alpha = 1.0
            })
        } else {
            
            UIView.animate(withDuration: 1, delay: 0.1, options: .curveEaseOut, animations: {
                self.fadeOutView.alpha = 0.0
            })
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            
            let track = UIStoryboard(name: "Map", bundle: nil)
            guard let trackVC = track.instantiateViewController(withIdentifier: "trackVC") as? TrackViewController else { return }
            trackVC.modalPresentationStyle = .overCurrentContext
            self.present(trackVC, animated: true, completion: nil)
            
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
        self.fadeOutView.alpha = 0.0
        }
//        mapSetting.isHidden = false
    }
    
    @IBAction func mapSetting(_ sender: UIButton) {
        
        googleMapView.clear()
    }
    
    func setAnimate() {
        
        fadeOutView.alpha = 0.0
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setAnimate()
        
        guard let center = userLocationManager.location?.coordinate else { return }
               
               let myArrange = GMSCameraPosition.camera(withTarget: center, zoom: 16.0)
        
        googleMapView.animate(to: myArrange)
        navigationController?.navigationBar.barStyle = .black
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        searchController = UISearchController(searchResultsController: autocompleteController)
        searchController?.searchResultsUpdater = resultsViewController
        
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        
        definesPresentationContext = true
        
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.modalPresentationStyle = .popover
        
        tableDataSource = GMSAutocompleteTableDataSource()
        tableDataSource?.delegate = self
        
        userLocationManager.delegate = self
        
        setUserLocation()
        
        setNavBar()
        
        setupBtns()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setAlert()
    }
    
    func keepTrackUserLocation() {
        
        userLocationManager.allowsBackgroundLocationUpdates = true
        userLocationManager.pausesLocationUpdatesAutomatically = false
        userLocationManager.requestAlwaysAuthorization()
    }
    
    func didUpdateAutocompletePredictionsForTableDataSource(tableDataSource: GMSAutocompleteTableDataSource) {
        // Turn the network activity indicator off.
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        // Reload table data.
        searchDisplayController?.searchResultsTableView.reloadData()
    }
    
    func didRequestAutocompletePredictionsForTableDataSource(tableDataSource: GMSAutocompleteTableDataSource) {
        // Turn the network activity indicator on.
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        // Reload table data.
        searchDisplayController?.searchResultsTableView.reloadData()
    }
    
    func setNavBar() {
        
        let image = UIImage()
        navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        navigationController?.navigationBar.shadowImage = image
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func trackingUserLocation() {
        
        guard let center = userLocationManager.location?.coordinate else { return }
        
        let myArrange = GMSCameraPosition.camera(withTarget: center, zoom: 16.0)
        
        googleMapView.camera = myArrange
        currentPosition = center
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: center.latitude, longitude: center.longitude)
        marker.title = "1"
        //        marker.icon = UIImage(named: "Icon_Map_BG")
        marker.icon = LocationStepsManager.shared.markerView()
        marker.map = googleMapView
    }
    
    
    // MARK: - Location Authorization Alert
    func setAlert() {
        
        if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .restricted {
            
            let alertController = UIAlertController(title: "定位權限已關閉",
                                                    message: "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(
                
                title: "確認", style: .default, handler: nil)
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            userLocationManager.startUpdatingLocation()
            userLocationManager.desiredAccuracy = kCLLocationAccuracyBest
            userLocationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
            
        } else {
            print("123")
        }
    }
    
    // MARK: - User Location Button
    func setUserLocation() {
        
        googleMapView.delegate = self
        
        googleMapView.isMyLocationEnabled = true
        
        googleMapView.settings.myLocationButton = true
        
        googleMapView.settings.rotateGestures = false
        
        googleMapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 64)
        
        if let mapStyleURL = Bundle.main.url(forResource: "MapDarkMode", withExtension: "json") {
            
            googleMapView.mapStyle = try? GMSMapStyle(contentsOfFileURL: mapStyleURL)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        //
        //        let camera = GMSCameraPosition.camera(withLatitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude, zoom: 18.0)
        //
        //        self.googleMapView.animate(to: camera)
        
        print("didUpdateLocations: \(location)")
        
        let marker = GMSMarker()
        
        marker.map = googleMapView
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        let marker = GMSMarker()
        
        marker.map = googleMapView
    }
    
    // MARK: - Button UI
    func setupBtns() {
        
        startExplore.layer.cornerRadius = 50
        startExplore.layer.shadowOffset = CGSize(width: 2, height: 2)
        startExplore.layer.shadowOpacity = 0.7
        startExplore.layer.shadowRadius = 5
        startExplore.layer.shadowColor = UIColor.gray.cgColor
        
        mapSetting.layer.cornerRadius = 27
        mapSetting.layer.shadowOffset = CGSize(width: 2, height: 2)
        mapSetting.layer.shadowOpacity = 0.7
        mapSetting.layer.shadowRadius = 5
        mapSetting.layer.shadowColor = UIColor.gray.cgColor
    }
    
    func setTimer() {
        
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            
            print("2")
            
            guard let cord = self.userLocationManager.location?.coordinate,
                  let currentPosition = self.currentPosition else { return }
            
            let outCome = LocationStepsManager.shared.getDistance(lat1: currentPosition.latitude, lng1: currentPosition.longitude, lat2: cord.latitude, lng2: cord.longitude)
            
            print("3")
            
            if outCome > 0.001 {
                
                self.currentPosition = cord
                
                self.userLocation.append(cord)
                
                let marker = GMSMarker()
                
                marker.position = CLLocationCoordinate2D(latitude: cord.latitude, longitude: cord.longitude)
                marker.title = "1"
                //            marker.icon = UIImage(named: "Icon_Map_BG")
                marker.icon = LocationStepsManager.shared.markerView()
                marker.map = self.googleMapView
            } else {
                return
            }
        }
    }
}

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
//        guard let apple = currentPosition else { return }
//        
//        let outCome = LocationStepsManager.shared.getDistance(lat1: apple.latitude, lng1: apple.longitude, lat2: position.target.latitude, lng2: position.target.longitude)
//        print(position)
//        if outCome > 0.00001 {
//            
//            self.currentPosition = position.target
//            
//            self.userLocation.append(position.target)
//            
//            let marker = GMSMarker()
//            
//            marker.position = CLLocationCoordinate2D(latitude: position.target.latitude, longitude: position.target.longitude)
//            marker.title = "1"
//            //            marker.icon = UIImage(named: "Icon_Map_BG")
//            marker.icon = LocationStepsManager.shared.markerView()
//            marker.map = googleMapView
//        } else {
//            return
//        }
    }
}


extension MapViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        googleMapView.clear()
        
        let marker = GMSMarker()
        marker.position = place.coordinate
        marker.title = place.name
        marker.snippet = place.formattedAddress
        let camera = GMSCameraPosition.camera(withTarget: place.coordinate, zoom: 16.0)
        googleMapView.animate(to: camera)
        marker.map = googleMapView
        
        
        marker.tracksInfoWindowChanges = true
        
        print("Place name: \(place.name ?? "")")
        print("Place ID: \(place.placeID ?? "")")
        print("Place attributions: \(place.attributions ?? nil)")
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

extension MapViewController: GMSAutocompleteResultsViewControllerDelegate {
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        
        searchController?.isActive = false
        
        print("Place name: \(place.name ?? "")")
        print("Place address: \(place.formattedAddress ?? "")")
        print("Place attributions: \(place.attributions ?? nil)")
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

extension MapViewController: GMSAutocompleteTableDataSourceDelegate {
    
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace) {
        
        searchDisplayController?.isActive = false
        
        print("Place name: \(place.name ?? "")")
        print("Place address: \(place.formattedAddress ?? "")")
        print("Place attributions: \(place.attributions ?? nil)")
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
        tableDataSource?.sourceTextHasChanged(searchString)
        return false
    }
    func tableDataSource(tableDataSource: GMSAutocompleteTableDataSource, didSelectPrediction prediction: GMSAutocompletePrediction) -> Bool {
        return true
    }
}

