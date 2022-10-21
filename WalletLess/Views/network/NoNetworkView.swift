//  Created by Filip Kjamilov on 20.10.22.

import SwiftUI

struct NoNetworkView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    var body: some View {
        ZStack {
            NoNetworkViewGradient()
            
            HStack {
                Image(uiImage: UIImage(named: "NoInternet.png")!)
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 150, maxWidth: 150, maxHeight: 100)
                    .padding(.all, 7)
                VStack(alignment: .leading) {
                    Text("No internet".localized(language))
                        .font(.title3)
                        .foregroundColor(.primary)
                        .bold()
                    Text("Cannot Scan".localized(language))
                        .font(.caption)
                        .foregroundColor(.primary)
                        .bold()
                }
            }
            .frame(minWidth: 0,
                   maxWidth: .infinity,
                   alignment: .topLeading)
            .padding(.leading, 10)
        }
        .padding(.leading, 5)
        .padding(.trailing, 5)
    }
}

struct NoNetworkView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            ScrollView {
                VStack {
                    NoNetworkView()

                    MerchantImageNameCardView(merchant: MerchantDto(name: "Vero",
                                                                    downloadedImage: (UIImage(named: "Elektrometal.png")?.jpegData(compressionQuality: 1)!)!,
                                                                    locations: nil))
                    MerchantImageNameCardView(merchant: MerchantDto(name: "TopShop",
                                                                    downloadedImage: (UIImage(named: "Elektrometal.png")?.jpegData(compressionQuality: 1)!)!,
                                                                    locations: nil))
                    MerchantImageNameCardView(merchant: MerchantDto(name: "Neptun",
                                                                    downloadedImage: (UIImage(named: "Elektrometal.png")?.jpegData(compressionQuality: 1)!)!,
                                                                    locations: nil))
                }
            }
            .background(
                GradientBackground()
            )
            .navigationTitle("Merchants".localized(.english_us))
        }
    }

}
