//
//  MapViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/1/30.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    @IBOutlet weak var googleMapView: GMSMapView!
    
    lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self 
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search"
        search.searchBar.sizeToFit()
        search.searchBar.searchBarStyle = .prominent
        search.searchBar.delegate = self
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        googleMapView.delegate = self
        
        let camera = GMSCameraPosition.camera(withLatitude: 25.042614, longitude: 121.564863, zoom: 18.0)
        googleMapView.camera = camera
        
        googleMapView.mapType = .normal
        
        let marker = GMSMarker()
        
        marker.position = CLLocationCoordinate2D(latitude: 25.042614, longitude: 121.564863)
        marker.map = googleMapView
        marker.title = "我的位置"
        marker.snippet = "信義區"
        marker.icon = GMSMarker.markerImage(with: .blue)
        
        
        setNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {

          }
    
    func setNavBar() {
        
        let image = UIImage()
        navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        navigationController?.navigationBar.shadowImage = image
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
       
    }

}

// MARK: - SearchBar
extension MapViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!)
    }
}

extension MapViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        <#code#>
    }
}
