//  Created by Filip Kjamilov on 20.10.22.

import SwiftUI

struct AlertView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    var imageNameAsset: String
    var headerText: String
    var description: String
    
    var body: some View {
        ZStack {
            
            AlertViewGradient()
            
            HStack {
                Image(uiImage: UIImage(named: imageNameAsset)!)
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 150, maxWidth: 150, maxHeight: 100)
                    .padding(.all, 7)
                VStack(alignment: .leading) {
                    Text(headerText.localized(language))
                        .font(.title3)
                        .foregroundColor(.primary)
                        .bold()
                    Text(description.localized(language))
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
                    AlertView(imageNameAsset: "NoInternet.png",
                              headerText: "No internet",
                              description: "Cannot Scan")
                    AlertView(imageNameAsset: "NoLocation.png",
                              headerText: "Location permission denied",
                              description: "Cards will not be sorted!")
                }
            }
            .background(
                GradientBackground()
            )
            .navigationTitle("Merchants".localized(.english_us))
        }
    }
    
}
