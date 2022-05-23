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
                if realmManager.merchants.filter({ !$0.isInvalidated }).count == 0 {
                    VStack {
                        Image(systemName: "barcode.viewfinder")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .foregroundColor(.primary)
                        Text("Please scan some cards.")
                            .font(.system(size: 18))
                            .foregroundColor(.primary)
                            .padding()
                    }
                } else {
                    ScrollView {
                        ForEach(realmManager.merchants.filter({ !$0.isInvalidated }), id: \.id) { merchant in
                            
                            Image(uiImage: UIImage(data: merchant.downloadedImage!)!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(15)
                                .padding(.all, 3)
                                .padding(.leading, 7)
                                .padding(.trailing, 7)
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
                }
                // Modal view for showing the card details
                ModalView(isShowing: $isPresentingSheet, merchant: $currentMerchant)
            }
            .navigationBarTitle("Dashboard", displayMode: .large)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                GradientBackground()
            )
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

public struct GradientBackground: View {
    public var body: some View {
        ZStack {
            LinearGradient(colors: [Color.cyan.opacity(0.7), Color.purple.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
            Circle()
                .frame(width: 300)
                .foregroundStyle(LinearGradient(colors: [Color.mint.opacity(0.5), Color.purple.opacity(0.6)], startPoint: .top, endPoint: .leading))
                .blur(radius: 10)
                .offset(x: -100, y: -150)
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .frame(width: 500, height: 500)
                .foregroundStyle(LinearGradient(colors: [Color.purple.opacity(0.6), Color.mint.opacity(0.5)], startPoint: .top, endPoint: .leading))
                .offset(x: 300)
                .blur(radius: 30)
                .rotationEffect(.degrees(30))
            
        }.ignoresSafeArea(.all)
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard(tabSelection: Binding.constant(1))
            .environmentObject(RealmManager())
    }
}
