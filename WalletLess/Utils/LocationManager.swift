//  Created by fkjamilov on 15.10.22.

import Foundation
import CoreLocation
import Combine

final class LocationManager: NSObject, ObservableObject {
    
    @Published var deviceLocation: CLLocation = CLLocation()
    
    // MARK: -
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let deviceLocation = locations.first else {
            return
        }
        DispatchQueue.main.async { self.deviceLocation = deviceLocation }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // TODO: FKJ - ErrorHandling
        print(error.localizedDescription)
    }
    
}

extension LocationManager: LocationService {

    public func startUpdatingLocation() {
        self.locationManager.startUpdatingLocation()
    }
    
    public func stopUpdatingLocation() {
        self.locationManager.stopUpdatingLocation()
    }
    
}

// TODO: FKJ - Transfer and document
protocol LocationService {
    
    func startUpdatingLocation()
    
    func stopUpdatingLocation()
    
}
