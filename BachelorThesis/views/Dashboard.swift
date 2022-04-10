//  Created by Filip Kjamilov on 27.2.22.

import CoreLocation
import SwiftUI
import RealmSwift

struct Dashboard: View {
    
    @EnvironmentObject var realmManager: RealmManager
    @Binding var tabSelection: Int
    @State private var isPresentingSheet = false
    @State private var isPresentingConfirmationDialog = false
    @State private var currentMerchant: MerchantDto = MerchantDto()
    
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

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard(tabSelection: Binding.constant(1))
            .environmentObject(RealmManager())
    }
}
