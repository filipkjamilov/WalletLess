//  Created by Filip Kjamilov on 27.2.22.

import SwiftUI
import RealmSwift

struct Dashboard: View {
    
    @EnvironmentObject var realmManager: RealmManager
    @State private var isPresentingSheet = false
    @State private var currentMerchant: MerchantDto = MerchantDto(name: "Test",
                                                                  image: "Test image",
                                                                  locations: nil,
                                                                  scannedCode: nil,
                                                                  typeOfCode: nil)
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(realmManager.merchants, id: \.id) { merchant in
                        
                        Image(uiImage: UIImage(data: merchant.downloadedImage!)!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(15)
                            .padding(.top, 10)
                            .padding(.bottom, 10)
                            .listRowInsets(.init())
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    realmManager.deleteMerchant(id: merchant.id)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .onTapGesture {
                                currentMerchant = merchant
                                isPresentingSheet.toggle()
                                print("Tapped")
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
        Dashboard()
            .environmentObject(RealmManager())
    }
}
