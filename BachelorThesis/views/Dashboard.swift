//  Created by Filip Kjamilov on 27.2.22.

import CoreLocation
import SwiftUI
import RealmSwift
import Combine

struct Dashboard: View {
    
    @EnvironmentObject var realmManager: RealmManager
    @Binding var tabSelection: Int
    @State private var isPresentingSheet = false
    @State private var isPresentingConfirmationDialog = false
    @State private var currentMerchant: MerchantDto = MerchantDto()
    
    // MARK: - Location properties
    
    @ObservedObject private var viewModel = LocationViewModel()
    @State private var currentLocation = CLLocation()
    @State private var cancellable: AnyCancellable?
    
    private func startObservingLocation() {
        cancellable = viewModel.$location.sink { location in
            
            guard let location = location else {
                return
            }
            
            currentLocation = location
            
            if let localRealm = self.realmManager.localRealm {
                
                try? localRealm.write {
                    
                    self.realmManager.merchants.forEach { merchant in
                        merchant.distance = .greatestFiniteMagnitude
                        merchant.locations.forEach { merchantLocation in
                            let distance = currentLocation
                                .distance(from: CLLocation(latitude: merchantLocation.latitude,
                                                           longitude: merchantLocation.longitude))
                                                        
                            if merchant.distance > distance { merchant.distance = distance }
                        }
                    }
                    
                    self.realmManager.merchants.sort { $0.distance < $1.distance }
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    ForEach(realmManager.merchants.filter({ !$0.isInvalidated }), id: \.id) { merchant in
                        
                        Image(uiImage: UIImage(data: merchant.downloadedImage!)!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(15)
                            .padding(.top, 10)
                            .padding(.bottom, 10)
                            .listRowInsets(.init())
                            .onTapGesture {
                                currentMerchant = merchant
                                isPresentingSheet.toggle()
                            }
                            .onLongPressGesture {
                                currentMerchant = merchant
                                isPresentingConfirmationDialog = true
                            }
                            .alert("Are you sure you want to remove \(currentMerchant.name) from the list?", isPresented: $isPresentingConfirmationDialog) {
                                Button("Confirm", role: .destructive) {
                                    realmManager.deleteMerchant(id: currentMerchant.id)
                                    currentMerchant = MerchantDto()
                                }
                                Button("Cancel", role: .cancel) { /* no-op */ }
                            }
                    }
                }
                .navigationBarTitle("Dashboard", displayMode: .inline)
                // Modal view for showing the card details
                ModalView(isShowing: $isPresentingSheet, merchant: $currentMerchant)
            }
        }
        .onAppear {
            /// Start observing location when user is on `Dashboard`.
            startObservingLocation()
        }
        .onDisappear {
            /// Stop observing location when user not on `Dashboard`.
            cancellable?.cancel()
        }
    }
}

func generateCode(from string: String, codeType: String?) -> UIImage {
    let data = Data(string.utf8)
    let context = CIContext()
    let fallbackCodeType = "CICode128BarcodeGenerator"
    
    if let filter = CIFilter(name: codeType ?? fallbackCodeType) {
        filter.setValue(data, forKey: "inputMessage")
        
        if let barcodeImage = filter.outputImage {
            if let barcodeCGImage = context.createCGImage(barcodeImage, from: barcodeImage.extent) {
                return UIImage(cgImage: barcodeCGImage)
            }
        }
    }
    
    return UIImage(systemName: "xmark") ?? UIImage()
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
        guard let currentLocation = locations.first else {
            return
        }
        DispatchQueue.main.async { self.location = currentLocation }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // TODO: FKJ - ErrorHandling
        print(error.localizedDescription)
    }
    
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard(tabSelection: Binding.constant(1))
            .environmentObject(RealmManager())
    }
}
