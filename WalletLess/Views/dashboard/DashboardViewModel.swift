//  Created by fkjamilov on 15.10.22.

import Foundation
import CoreLocation
import Combine
import SwiftUI

final class DashboardViewModel: ObservableObject {
    
    @Published var isPresentingSheet = false
    @Published var isPresentingConfirmationDialog = false
    @Published var realmManager = RealmManager.shared
    
    // MARK: - Private
    
    private var locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()
    
    // TODO: FKJ - Check if we can implement better solution for sorting
    init() {
        realmManager.$merchants.sink { _ in
            self.objectWillChange.send()
        }.store(in: &cancellables)
    }
    
    public func startSortingCards() {
        locationManager.startUpdatingLocation()
        
        locationManager.$deviceLocation.sink { newLocation in
            
            self.realmManager.sortCards(with: newLocation)
            
        }.store(in: &cancellables)
        
    }
    
    public func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        cancellables.removeAll(keepingCapacity: false)
    }
    
}
