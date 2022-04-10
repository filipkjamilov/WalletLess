//  Created by Filip Kjamilov on 9.4.22.

import CoreLocationUI
import CoreLocation
import MapKit
import Combine
import SwiftUI



struct Location: View {
    
//    @ObservedObject private var viewModel = LocationViewModel()
//    @State private var region = MKCoordinateRegion.defaultRegion
//    @State private var cancellable: AnyCancellable?
//
//    private func setCurrentLocation() {
//        cancellable = viewModel.$location.sink { location in
//            region = MKCoordinateRegion(center: location?.coordinate ?? CLLocationCoordinate2D(), latitudinalMeters: 500, longitudinalMeters: 500)
//        }
//    }
    
    var body: some View {
        
        Text("da")
        
//        VStack {
//            if viewModel.location != nil {
//                Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: nil)
//            } else {
//                Text("Locating user...")
//            }
//        }
//
//        .onAppear {
//            setCurrentLocation()
//        }
    }
    
    
}

struct Location_Previews: PreviewProvider {
    static var previews: some View {
        Location()
    }
}


