//  Created by Filip Kjamilov on 15.10.22.

import Foundation
import CoreLocation
import Combine
import SwiftUI

final class DashboardViewModel: ObservableObject {
    
    @Published var isPresentingSheet = false
    @Published var isPresentingConfirmationDialog = false
    var realmManager = RealmManager.shared
    
    private var locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()
    
    public func viewAppeared() {
        locationManager.startUpdatingLocation()
        observeDeviceLocation()
        observeMerchants()
    }
    
    public func viewDissapeared() {
        locationManager.stopUpdatingLocation()
        cancellables.removeAll(keepingCapacity: false)
    }
    
    // MARK: - Private
    
    private func observeDeviceLocation() {
        locationManager.$deviceLocation.sink { newLocation in
            self.realmManager.sortCards(with: newLocation)
        }.store(in: &cancellables)
    }
    
    private func observeMerchants() {
        realmManager.$merchants.sink { _ in
            self.objectWillChange.send()
            // TODO: FKJ - Remove print
            print("Changed: No of Merchnats: \(self.realmManager.merchants.count)")
        }.store(in: &cancellables)
    }
    
}
