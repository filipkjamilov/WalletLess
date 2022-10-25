//  Created by Filip Kjamilov on 15.10.22.

import Foundation
import CoreLocation
import Combine

final class LocationManager: NSObject, ObservableObject {
    
    @Published var deviceLocation: CLLocation = CLLocation()
    let clLocationManager = CLLocationManager()
    
    // MARK: -
    
    static let shared = LocationManager()
    
    private override init() {
        super.init()
        clLocationManager.requestAlwaysAuthorization()
        clLocationManager.delegate = self
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Hello")
        guard let deviceLocation = locations.first else {
            return
        }
        DispatchQueue.main.async {
            self.deviceLocation = deviceLocation
            print("Location updated!")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // TODO: FKJ - ErrorHandling
        print(error.localizedDescription)
    }
    
}

extension LocationManager: LocationService {
    
    public func startUpdatingLocation() {
        clLocationManager.startUpdatingLocation()
    }
    
    public func stopUpdatingLocation() {
        clLocationManager.stopUpdatingLocation()
    }
    
    public func isAuthorized() -> Bool {
        return clLocationManager.authorizationStatus != .denied
        && clLocationManager.authorizationStatus != .notDetermined
    }
    
}

// TODO: FKJ - Transfer and document
protocol LocationService {
    
    func startUpdatingLocation()
    
    func stopUpdatingLocation()
    
    func isAuthorized() -> Bool
    
}
