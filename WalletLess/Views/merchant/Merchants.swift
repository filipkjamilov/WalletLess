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
    
    @Binding var tabSelection: Int
    
    @StateObject private var viewModel = MerchantsViewModel()
    @StateObject private var networkManger = NetworkManager.shared
    
    @State private var scannedCode: String?
    @State private var currentMerchant: MerchantDto = MerchantDto()
    @State private var result: Result<MFMailComposeResult, Error>? = nil
    @State private var searchText = ""
    
    var codeScannerView: CodeScannerView {
        CodeScannerView(codeTypes: [.qr, .code128, .code39, .code93, .code39Mod43, .ean8, .ean13],
                        isTorchOn: viewModel.isTorchOn) { response in
            if case let .success(result) = response {
                // Go to dashboard
                tabSelection = 1
                // Map the scanned code (barcode/qrcode)
                viewModel.mapScannedCode(with: result, merchant: currentMerchant)
                // Save scannedCode
                scannedCode = result.string
                // Dismiss scanner view
                viewModel.isPresentingScanner = false
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView() {
                    if !networkManger.isConnected {
                        AlertView(imageNameAsset: "NoInternet.png",
                                  headerText: "No internet",
                                  description: "Cannot Scan")
                    }
                    ForEach(viewModel.merchants.filter({ $0.name.contains(searchText) || searchText.isEmpty }), id: \.id) { merchant in
                        MerchantImageNameCardView(merchant: merchant)
                            .onTapGesture {
                                viewModel.isPresentingScanner = true
                                self.currentMerchant = merchant
                            }
                    }
                    /// This pins the `MerchantImageNameCardView` to top of the screen.
                    Spacer()
                }
                .searchable(text: $searchText, prompt: "Search".localized(language))
                .sheet(isPresented: $viewModel.isPresentingScanner) {
                    NavigationView {
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
                        }
                        .navigationBarTitle("", displayMode: .large)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button(action: { viewModel.isPresentingScanner.toggle() }) {
                                    Image(systemName: "arrow.left")
                                        .foregroundColor(.primary)
                                }
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: { viewModel.isTorchOn.toggle() }) {
                                    Image(systemName: viewModel.isTorchOn ? "flashlight.on.fill" : "flashlight.off.fill")
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                }
                .sheet(isPresented: $viewModel.isPresentingMailView) {
                    MailView(result: $result,
                             newSubject: "Requesting a new merchant",
                             newMessageBody: "Dear Walletless, I would like to report the following...")
                }
                
                // Floating Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.presentMailSheet()
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
                        .alert("Mail provider missing".localized(language), isPresented: $viewModel.alertForMail, actions: {})
                        
                    }
                }
            }
            .navigationBarTitle("Merchants".localized(language), displayMode: .large)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                GradientBackground()
            )
            .onAppear() {
                viewModel.fetchDataIfNeeded()
                viewModel.isTorchOn = false
                searchText = ""
            }
        }
    }
    
}

struct Merchants_Previews: PreviewProvider {
    static var previews: some View {
        Merchants(tabSelection: Binding.constant(2))
    }
}
