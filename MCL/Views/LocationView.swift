//
//  LocationView.swift
//  MCL
//
//  Created by Francesca Ferrini on 21/05/24.
//

import SwiftUI
import CoreLocation

struct LocationView: View {
    
    //LocationView variables
    @ObservedObject var locationManager: SearchLocation
    @Binding var isPresented: Bool
    @State private var isTextFieldClicked = false
    @State private var currentStreet = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                    TextField("Find location here", text: $locationManager.searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.vertical, 10)
                        .padding(.horizontal, 5)
                        .onTapGesture {
                            isTextFieldClicked = true
                            if locationManager.searchText.isEmpty{
                                
                            }
                            
                        }
                    
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                .padding([.horizontal, .top], 16)
                
                //Checking the current location
                if isTextFieldClicked && locationManager.searchText.isEmpty && !currentStreet.isEmpty {
                    Button(action: {
                        geocodeAddressString(currentStreet) { placemark in
                            if let placemark = placemark {
                                locationManager.selectedPlace = placemark
                                locationManager.fetchedPlaces = nil
                                isPresented = false
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(.blue)
                            Text(currentStreet)
                                .foregroundColor(.blue)
                                .padding(.trailing, 5)
                            
                        }
                        .padding(10)
                        .frame(maxWidth: .infinity)
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    .padding(.top, 5)
                    .padding(.horizontal)
                    
                }
                
                
                //List of positions
                if let places = locationManager.fetchedPlaces, !places.isEmpty {
                    List {
                        ForEach(places, id: \.self) { place in
                            HStack(spacing: 15) {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(place.name ?? "")
                                        .font(.title3.bold())
                                    Text(place.locality ?? "")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                locationManager.selectedPlace = place
                                locationManager.fetchedPlaces = nil //Hide list
                                isPresented = false //Close view
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Find Location")

            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .onAppear {
                updateCurrentStreet()
            }
            .onReceive(locationManager.$userLocation) { location in
                updateCurrentStreet()
            }
        }
    }
    
    
    
    func updateCurrentStreet() {
        guard let location = locationManager.userLocation else { return }
        getAddress(from: location) { placemark in
            currentStreet = placemark?.thoroughfare ?? "Unknown Location"
            
        }
    }
    
    
    //MARK: These two methods are used to perform reverse geocoding (coordinates to address) and direct geocoding (address to coordinates) using the iOS Core Location framework.
    
    //This method takes a location (represented by an instance of CLLocation) and uses a CLGeocoder to obtain the address associated with that location.Reverse geocoding is performed via the reverseGeocodeLocation method of the CLGeocoder. When the geocoding process is complete, the completion call is made returning the CLPlacemark corresponding to the address.
    func getAddress(from location: CLLocation, completion: @escaping (CLPlacemark?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil else {
                print("Reverse geocoding error: \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?.first else {
                print("No placemarks found")
                completion(nil)
                return
            }
            
            completion(placemark)
        }
    }
    
    
    //This method takes an address in string format and uses a CLGeocoder to obtain the coordinates associated with that address.Direct geocoding is performed via the CLGeocoder's geocodeAddressString method. When the geocoding process is complete, the completion call is made returning the CLPlacemark corresponding to the address.
    func geocodeAddressString(_ address: String, completion: @escaping (CLPlacemark?) -> Void) {
        CLGeocoder().geocodeAddressString(address) { placemarks, error in
            guard error == nil else {
                print("Geocoding error: \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?.first else {
                print("No placemarks found")
                completion(nil)
                return
            }
            
            completion(placemark)
        }
    }
}


struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(locationManager: SearchLocation(), isPresented: .constant(true))
    }
}
