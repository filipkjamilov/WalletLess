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
    
    @EnvironmentObject var realmManager: RealmManager
    @Binding var tabSelection: Int
    @ObservedObject private var viewModel = MerchantsViewModel()
    @ObservedObject private var networkManger = NetworkManager()
    @State private var isPresentingScanner = false
    @State private var isPresentingMailView = false
    @State private var scannedCode: String?
    @State private var currentMerchant: MerchantDto = MerchantDto()
    @State var result: Result<MFMailComposeResult, Error>? = nil
    
    @State private var searchText = ""
    
    
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
                        CodeScannerView(codeTypes: [.qr, .code128]) { response in
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
                    .sheet(isPresented: $isPresentingMailView) {
                        MailView(result: $result, newSubject: "Requesting a new merchant", newMessageBody: "Dear Walletless, I would like to report the following...")
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
            }
        }
    }
    
    // MARK: -
    
    private func presentMailSheet() {
        if MFMailComposeViewController.canSendMail() {
            self.isPresentingMailView = true
        } else {
            // TODO: FKJ - ALLERT!
            print("Present alert that mail sending is not possible")
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
                                    typeOfCode: .unknown)
        }
        
        scannedCode = result.string
    }
}

struct Merchants_Previews: PreviewProvider {
    static var previews: some View {
        Merchants(tabSelection: Binding.constant(2))
            .environmentObject(RealmManager())
    }
}
