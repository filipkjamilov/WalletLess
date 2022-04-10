//  Created by Filip Kjamilov on 27.2.22.

import CoreLocation
import SwiftUI
import RealmSwift
import Combine
import MapKit

struct Dashboard: View {
    
    @EnvironmentObject var realmManager: RealmManager
    @Binding var tabSelection: Int
    @State private var isPresentingSheet = false
    @State private var isPresentingConfirmationDialog = false
    @State private var currentMerchant: MerchantDto = MerchantDto()
    
    // MARK: - Location properties
    
    @ObservedObject private var viewModel = LocationViewModel()
    @State private var currentLocation = CLLocation.defaultLocation
    @State private var cancellable: AnyCancellable?
    
    private func setCurrentLocation() {
        cancellable = viewModel.$location.sink { location in
            currentLocation = location ?? CLLocation()
            
//            self.realmManager.merchants.forEach { merchant in
//
//                merchant.locations.forEach { location in
//                    
//                }
//            }
            
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
                                    // TODO: FKJ - Make currentMerchant optional and make it nil here.
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
            setCurrentLocation()
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
        guard let currentLocation = locations.last else {
            return
        }
        
        DispatchQueue.main.async {
            self.location = currentLocation
//            print(currentLocation.coordinate)
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}

extension CLLocation {
    
    static var defaultLocation: CLLocation {
        CLLocation.init(latitude: 29.726819, longitude: -95.393692)
    }
    
}


struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard(tabSelection: Binding.constant(1))
            .environmentObject(RealmManager())
    }
}
