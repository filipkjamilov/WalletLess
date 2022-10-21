//  Created by Filip Kjamilov on 27.2.22.

import SwiftUI

struct MerchantImageNameCardView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    var merchant: MerchantDto
    
    var body: some View {

        ZStack {
            CardViewGradient()
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                    }, label: {
                        Image(systemName: "creditcard")
                            .font(.title3)
                            .frame(width: 35, height: 35)
                            .background(Color.primary.opacity(0.3))
                            .clipShape(Circle())
                            .foregroundColor(.white)
                    })
                    .padding()
                    .shadow(radius: 2)
                    
                }
                Spacer()
            }
            
            HStack {
                Image(uiImage: UIImage(data: merchant.downloadedImage!)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 150, maxWidth: 150, minHeight: 70)
                    .cornerRadius(7)
                    .padding(.all, 7)
                
                Text(merchant.name)
                    .font(.title2)
                    .foregroundColor(.primary)
                    .bold()
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

struct MerchantImageNameCardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScrollView {
                VStack {
                    MerchantImageNameCardView(merchant: MerchantDto(name: "Vero",
                                                                    image: "https://www.linkpicture.com/q/Vero.png",
                                                                    locations: nil))
                    MerchantImageNameCardView(merchant: MerchantDto(name: "TopShop",
                                                                    image: "https://www.linkpicture.com/q/Topshop.jpeg",
                                                                    locations: nil))
                    MerchantImageNameCardView(merchant: MerchantDto(name: "Neptun",
                                                                    image: "https://www.linkpicture.com/q/Neptun.png",
                                                                    locations: nil))
                }
            }
            .background(
                GradientBackground()
            )
            .navigationTitle("Merchants".localized(.macedonian))
        }
    }
}
