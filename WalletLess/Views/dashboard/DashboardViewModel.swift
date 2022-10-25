//  Created by Filip Kjamilov on 15.10.22.

import Foundation
import CoreLocation
import Combine
import SwiftUI

final class DashboardViewModel: ObservableObject {
    
    @Published var isPresentingSheet = false
    @Published var isPresentingConfirmationDialog = false
    @Published var locationServicesEnabled = false
    var realmManager = RealmManager.shared
    
    private var locationManager = LocationManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    public func viewAppeared() {
        observeDeviceLocation()
        observeMerchants()
    }
    
    public func viewDissapeared() {
        locationManager.stopUpdatingLocation()
        cancellables.removeAll(keepingCapacity: false)
    }
    
    // MARK: - Private
    
    private func observeDeviceLocation() {
        if locationManager.isAuthorized() {
            locationServicesEnabled = true
            locationManager.startUpdatingLocation()
            locationManager.$deviceLocation.sink { newLocation in
                self.realmManager.sortCards(with: newLocation)
            }.store(in: &cancellables)
        } else {
            locationServicesEnabled = false
        }
    }
    
    private func observeMerchants() {
        realmManager.$merchants.sink { _ in
            self.objectWillChange.send()
        }.store(in: &cancellables)
    }
    
}
