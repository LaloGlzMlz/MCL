//
//  SearchLocation.swift
//  MCL
//
//  Created by Francesca Ferrini on 20/05/24.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit
import Combine

class SearchLocation: NSObject, ObservableObject, MKMapViewDelegate, CLLocationManagerDelegate{
    
    @Published var mapView: MKMapView = .init()
    @Published var manager: CLLocationManager = .init()
    @Published var searchText: String = ""
    @Published var fetchedPlaces: [CLPlacemark]?
    
    //UserLocation
    @Published var userLocation: CLLocation?
    
    var cancellable: AnyCancellable?
    
    override init() {
        super.init()
        manager.delegate = self
        mapView.delegate = self
        
        //Request access
        manager.requestWhenInUseAuthorization()
        cancellable = $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { value in
                if value != ""{
                    self.fetchPlaces(value: value)
                }else{
                    self.fetchedPlaces = nil
                }
            })
    }
    
    func fetchPlaces(value: String){
        Task{
            do{
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = value.lowercased()
                
                let response = try await MKLocalSearch(request: request).start()
                await MainActor.run(body: {
                    self.fetchedPlaces = response.mapItems.compactMap({ item -> CLPlacemark? in
                        return item.placemark
                    })
                })
            }
            catch{
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           // Handle updated locations here
           guard let currentLocation = locations.last else { return }
           self.userLocation = currentLocation
        
       }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus{
        case .authorizedAlways: manager.requestLocation()
        case .authorizedWhenInUse: manager.requestLocation()
        case .denied: handleLocationError()
        case .notDetermined: manager.requestWhenInUseAuthorization()
        default: ()
        }
    }
    
    func handleLocationError(){
       //
    }
}
