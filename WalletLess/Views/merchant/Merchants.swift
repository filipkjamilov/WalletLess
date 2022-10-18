//  Created by Filip Kjamilov on 27.2.22.

import SwiftUI
import Foundation
import FirebaseFirestore
import Firebase
import RealmSwift
import CodeScanner
import MessageUI

class MerchantsViewModel: ObservableObject {
    
    @Published var merchants = [MerchantDto]()
    let databaseName: String = "AllCards"
    
    func fetchDataIfNeeded() {
        let database = Database.database().reference().child(databaseName)
        
        database.observe(.value, with: { snap in
            
            guard let dict = snap.value as? [String:Any] else {
                return
            }
            
            if dict.count > self.merchants.count {
                self.merchants = dict.map { card in
                    let card = card.value as? [String: Any]
                    
                    let name = card?["cardName"] as? String ?? ""
                    let image = card?["cardImage"] as? String ?? ""
                    let locations = card?["locations"] as? [String: [String: Any]]
                    
                    return MerchantDto(name: name, image: image, locations: locations)
                }
            }
        })
    }
}

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
    }
}

struct Merchants: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    var realmManager = RealmManager.shared
    @Binding var tabSelection: Int
    @ObservedObject private var viewModel = MerchantsViewModel()
    @ObservedObject private var networkManger = NetworkManager()
    @State private var isPresentingScanner = false
    @State private var isPresentingMailView = false
    @State private var alertForMail = false
    @State private var scannedCode: String?
    @State private var currentMerchant: MerchantDto = MerchantDto()
    @State var result: Result<MFMailComposeResult, Error>? = nil
    
    @State private var searchText = ""
    @State private var isTorchOn = false
    
    var codeScannerView: CodeScannerView {
        CodeScannerView(codeTypes: [.qr, .code128, .code39, .code93, .code39Mod43, .ean8, .ean13],
                        isTorchOn: isTorchOn) { response in
            if case let .success(result) = response {
                // Go to dashboard
                tabSelection = 1
                // Map the scanned code (barcode/qrcode)
                mapScannedCode(with: result)
                // Dismiss scanner view
                isPresentingScanner = false
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if !networkManger.isConnected {
                    VStack {
                        Image(systemName: "wifi.slash")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .foregroundColor(.primary)
                        Text("Cannot establish connection!".localized(language))
                            .font(.system(size: 18))
                            .foregroundColor(.primary)
                            .padding()
                    }
                } else {
                    ScrollView() {
                        ForEach(viewModel.merchants.filter({ $0.name.contains(searchText) || searchText.isEmpty }), id: \.id) { merchant in
                            MerchantImageNameCardView(merchant: merchant)
                                .onTapGesture {
                                    isPresentingScanner = true
                                    self.currentMerchant = merchant
                                }
                        }
                        /// This pins the `MerchantImageNameCardView` to top of the screen.
                        Spacer()
                    }
                    .searchable(text: $searchText, prompt: "Search".localized(language))
                    .sheet(isPresented: $isPresentingScanner) {
                        ZStack {
                            
                            self.codeScannerView
                            
                            ZStack {
                                Image(systemName: "viewfinder")
                                    .resizable()
                                    .font(Font.title.weight(.ultraLight))
                                    .scaledToFit()
                                Rectangle()
                                    .fill(.red)
                                    .frame(height: 5)
                            }.frame(width: UIScreen.main.bounds.size.width-100,
                                    height: UIScreen.main.bounds.size.height-100,
                                    alignment: .center)
                            
                            VStack(spacing: 10) {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        isTorchOn.toggle()
                                    }, label: {
                                        Image(systemName: isTorchOn ? "flashlight.on.fill" : "flashlight.off.fill")
                                            .font(.title2)
                                            .frame(width: 50, height: 50)
                                            .background(networkManger.isConnected ? Color.blue : Color.gray)
                                            .clipShape(Circle())
                                            .foregroundColor(.white)
                                    })
                                    .padding(.trailing)
                                    .shadow(radius: 2)
                                    .padding(.bottom, 10)
                                    
                                }
                                // TODO: FKJ - Feature Show Gallery on camera view
//                                HStack {
//                                    Spacer()
//                                    Button(action: {
//                                        isGalleryPresented.toggle()
//                                        requestGalleryPermission()
//                                    }, label: {
//                                        Image(systemName: "photo.on.rectangle")
//                                            .font(.title2)
//                                            .frame(width: 50, height: 50)
//                                            .background(networkManger.isConnected ? Color.blue : Color.gray)
//                                            .clipShape(Circle())
//                                            .foregroundColor(.white)
//                                    })
//                                    .padding(.trailing)
//                                    .padding(.bottom, 10)
//                                    .shadow(radius: 2)
//                                }
                            }
                        }
                    }
                    .sheet(isPresented: $isPresentingMailView) {
                        MailView(result: $result,
                                 newSubject: "Requesting a new merchant",
                                 newMessageBody: "Dear Walletless, I would like to report the following...")
                    }
                }
                
                // Floating Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            presentMailSheet()
                        }, label: {
                            Image(systemName: "plus")
                                .font(.title2)
                                .frame(width: 50, height: 50)
                                .background(networkManger.isConnected ? Color.blue : Color.gray)
                                .clipShape(Circle())
                                .foregroundColor(.white)
                        })
                        .padding()
                        .shadow(radius: 2)
                        .disabled(!networkManger.isConnected)
                        .alert("Mail provider is missing. ", isPresented: $alertForMail, actions: {})
                        
                    }
                }
            }
            .navigationBarTitle("Merchants".localized(language), displayMode: .large)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                GradientBackground()
            )
            .onAppear() {
                self.viewModel.fetchDataIfNeeded()
                isTorchOn = false
                searchText = ""
            }
        }
    }
    
    // MARK: -
  
    // TODO: FKJ - Feature Show Gallery on camera view
//    private func requestGalleryPermission() {
//        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [self] (status) in
//            DispatchQueue.main.async { [self] in
//                showUI(for: status)
//            }
//        }
//    }
//
//    private func showUI(for status: PHAuthorizationStatus) {
//
//        switch status {
//        case .authorized:
//            print("Authorized")
//        case .limited:
//            print("Limited")
//        case .restricted:
//            print("Restricted")
//        case .denied:
//            print("Denied")
//        case .notDetermined:
//            break
//        @unknown default:
//            break
//        }
//    }
    
    private func presentMailSheet() {
        if MFMailComposeViewController.canSendMail() {
            self.isPresentingMailView = true
        } else {
            alertForMail.toggle()
            print("Mail provider is missing")
        }
    }
    
    fileprivate func mapScannedCode(with result: (ScanResult)) {
        switch result.type {
        case .code128:
            realmManager.addMerhant(name: currentMerchant.name,
                                    image: currentMerchant.image,
                                    locations: currentMerchant.locations,
                                    scannedCode: result.string,
                                    typeOfCode: .CICode128BarcodeGenerator)
        case .qr:
            realmManager.addMerhant(name: currentMerchant.name,
                                    image: currentMerchant.image,
                                    locations: currentMerchant.locations,
                                    scannedCode: result.string,
                                    typeOfCode: .CIQRCodeGenerator)
        default:
            realmManager.addMerhant(name: currentMerchant.name,
                                    image: currentMerchant.image,
                                    locations: currentMerchant.locations,
                                    scannedCode: result.string,
                                    typeOfCode: .CICode128BarcodeGenerator)
        }
        
        scannedCode = result.string
    }
}

struct Merchants_Previews: PreviewProvider {
    static var previews: some View {
        Merchants(tabSelection: Binding.constant(2))
    }
}
