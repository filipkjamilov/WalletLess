//  Created by Filip Kjamilov on 9.4.22.

import CoreLocationUI
import CoreLocation
import MapKit
import Combine
import SwiftUI

extension MKCoordinateRegion {
    
    static var defaultRegion: MKCoordinateRegion {
        MKCoordinateRegion(center: CLLocationCoordinate2D.init(latitude: 29.726819, longitude: -95.393692), latitudinalMeters: 100, longitudinalMeters: 100)
    }
    
}

struct Location: View {
    
    @ObservedObject private var viewModel = LocationViewModel()
    @State private var region = MKCoordinateRegion.defaultRegion
    @State private var cancellable: AnyCancellable?
    
    private func setCurrentLocation() {
        cancellable = viewModel.$location.sink { location in
            region = MKCoordinateRegion(center: location?.coordinate ?? CLLocationCoordinate2D(), latitudinalMeters: 500, longitudinalMeters: 500)
        }
    }
    
    var body: some View {
        
        VStack {
            if viewModel.location != nil {
                Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: nil)                
            } else {
                Text("Locating user...")
            }
        }
        
        .onAppear {
            setCurrentLocation()
        }
    }
    
    
}

struct Location_Previews: PreviewProvider {
    static var previews: some View {
        Location()
    }
}

final class LocationViewModel: NSObject, ObservableObject {
    
    @Published var location: CLLocation?
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
}

extension LocationViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else {
            return
        }
        
        DispatchQueue.main.async {
            self.location = currentLocation
            print(currentLocation.coordinate)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}
