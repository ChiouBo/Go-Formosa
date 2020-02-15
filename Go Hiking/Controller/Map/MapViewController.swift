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
    
    var path: GMSMutablePath!
    
    var userLocationManager = CLLocationManager()
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    
    var searchController: UISearchController?
    
    var resultView: UITextView?
    
    var searchBar: UISearchBar?
    
    var tableDataSource: GMSAutocompleteTableDataSource?
    
    @IBOutlet weak var googleMapView: GMSMapView!
    
    @IBOutlet weak var startExplore: UIButton!
    
    @IBOutlet weak var mapSetting: UIButton!
    
    @IBAction func startExplore(_ sender: UIButton) {
    }
    
    @IBAction func mapSetting(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setAlert()
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
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
    }
    
    // MARK: - Location Authorization Alert
    func setAlert() {
        
        if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .restricted {
            
            let alertController = UIAlertController(
                
                title: "定位權限已關閉",
                message: "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟",
                preferredStyle: .alert)
            
            let okAction = UIAlertAction(
                
                title: "確認", style: .default, handler: nil)
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            userLocationManager.startUpdatingLocation()
        } else {
            print("123")
        }
    }
    
    // MARK: - User Location Button
    func setUserLocation() {
        
//                googleMapView.delegate = self
        
        googleMapView.isMyLocationEnabled = true
        
        googleMapView.settings.myLocationButton = true
        
        googleMapView.settings.rotateGestures = false
        
        googleMapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 64)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude, zoom: 18.0)
        
        self.googleMapView.animate(to: camera)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
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

