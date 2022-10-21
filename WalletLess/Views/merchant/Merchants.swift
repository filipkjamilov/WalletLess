//  Created by Filip Kjamilov on 27.2.22.

import SwiftUI
import Foundation
import RealmSwift
import CodeScanner
import MessageUI
import Combine

struct Merchants: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    var realmManager = RealmManager.shared
    @Binding var tabSelection: Int
    @StateObject private var viewModel = MerchantsViewModel()
    @StateObject private var networkManger = NetworkManager()
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
                ScrollView() {
                    if !networkManger.isConnected {
                        NoNetworkView()
                    }
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
                        }
                    }
                }
                .sheet(isPresented: $isPresentingMailView) {
                    MailView(result: $result,
                             newSubject: "Requesting a new merchant",
                             newMessageBody: "Dear Walletless, I would like to report the following...")
                }
                //                }
                
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
                        .alert("Mail provider missing".localized(language), isPresented: $alertForMail, actions: {})
                        
                    }
                }
            }
            .navigationBarTitle("Merchants".localized(language), displayMode: .large)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                GradientBackground()
            )
            .viewDidLoad {
                viewModel.fetchDataIfNeeded()
            }
            .onAppear() {
                isTorchOn = false
                searchText = ""
            }
        }
    }
    
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
