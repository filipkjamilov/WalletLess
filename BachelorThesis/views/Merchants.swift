//  Created by Filip Kjamilov on 27.2.22.

import SwiftUI
import Foundation
import FirebaseFirestore
import Firebase
import RealmSwift

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
    
    @EnvironmentObject var realmManager: RealmManager
    @Binding var tabSelection: Int
    @ObservedObject private var viewModel = MerchantsViewModel()
    @State private var isPresentingScanner = false
    @State private var scannedCode: String?
    @State private var currentMerchant: MerchantDto = MerchantDto()
    
    @State private var searchText = ""
    
    var body: some View {
        
        NavigationView {
            ScrollView() {
                ForEach(viewModel.merchants.filter({ $0.name.contains(searchText) || searchText.isEmpty }), id: \.id) { merchant in
                    MerchantImageNameCardView(merchant: merchant)
                        .onTapGesture {
                            isPresentingScanner = true
                            self.currentMerchant = merchant
                        }
                }
                // This pins the VStack to top of the screen.
                Spacer()
            }
            .searchable(text: $searchText)
            .onAppear() {
                self.viewModel.fetchDataIfNeeded()
            }
            .sheet(isPresented: $isPresentingScanner) {
                CodeScannerView(codeTypes: [.qr, .code128]) { response in
                    if case let .success(result) = response {
                        
                        // Make optional? Should never happen to be empty!
                        // If no merchant is added it will add a default one wrongly done!
                        
                        tabSelection = 1
                        
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
                        isPresentingScanner = false
                        
                    }
                }
            }
            .navigationBarTitle("Merchants", displayMode: .inline)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.all)
            )
        }
    }
}

struct Merchants_Previews: PreviewProvider {
    static var previews: some View {
        Merchants(tabSelection: Binding.constant(2))
            .environmentObject(RealmManager())
    }
}
